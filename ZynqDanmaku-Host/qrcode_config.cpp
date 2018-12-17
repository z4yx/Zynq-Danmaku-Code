#include "qrcode_config.h"
#include "picojson.h"
#include <zbar.h>
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fstream>

// #define TEST_QRCODE
#ifndef IFUPDOWN_CONFIG_FILE
#define IFUPDOWN_CONFIG_FILE "/etc/network/interfaces.d/danmaku"
#endif

static const in6_addr IP6_ANY = IN6ADDR_ANY_INIT;
static struct{
    struct in_addr ipv4, mask_v4, gw_v4;
    struct in6_addr gw_v6;
    struct in6_addr ipv6;
    uint8_t prefixLen;
    std::string dns1;
    std::string server_url;
    bool dhcp;
}gCfg;

#define CHECK_THEN_POPULATE(key, default, converter, field) do{\
    auto r = extractString(key, default);\
    if(!r.first) {\
        printf("key %s not found\n", key);\
        return QrCodeContentErr;\
    }\
    int ret = converter(r.second, field);\
    if(ret) return ret;\
}while(0)

int ParseJSON(const std::string &json)
{
    using namespace std;
    picojson::value v;
    string err = picojson::parse(v, json);
    if (! err.empty()) {
        printf("json parser error: %s\n", err.c_str());
        return QrCodeContentErr;
    }
    if (v.is<picojson::object>()){
        auto &obj = v.get<picojson::object>();
        auto extractString = [&obj](const string& key, const string& fallback)->pair<bool,string>{
            if(obj.count(key) && obj[key].is<string>())
                return make_pair(true, obj[key].get<string>());
            else
                return make_pair(false, fallback);
        };

        auto dotsNotation2IPv4 = [](const string &ip, struct in_addr *field)->int{
            if(ip.empty()){
                field->s_addr = INADDR_ANY;
                return QrCodeParseOK;
            }
            if(inet_aton(ip.c_str(), field))
                return QrCodeParseOK;
            return QrCodeInvalidIPv4;
        };
        auto CIDR2IPv6 = [](const string &ip, struct in6_addr *field)->int{
            if(ip.empty()){
                *field = in6_addr(IN6ADDR_ANY_INIT);
                return QrCodeParseOK;
            }
            auto slash = find(ip.begin(), ip.end(), '/');
            if(inet_pton(AF_INET6, string(ip.begin(), slash).c_str(), field))
                return QrCodeParseOK;
            return QrCodeInvalidIPv6;
        };
        auto CIDR2PrefixLen = [](const string &ip, uint8_t *len)->int{
            if(ip.empty()){
                *len = 0;
                return QrCodeParseOK;
            }
            auto slash = find(ip.begin(), ip.end(), '/');
            if(slash == ip.end())
                return QrCodeInvalidIPv6;
            return 1 == sscanf(string(slash+1, ip.end()).c_str(), "%hhu", len) ?
                    QrCodeParseOK :
                    QrCodeInvalidIPv6;
        };
        auto CopyURL = [](const string &src, string* dst)->int{
            if(src.empty())
                return QrCodeInvalidURL;
            *dst = src;
            return QrCodeParseOK;
        };

        memset(&gCfg, 0, sizeof(gCfg));
        CHECK_THEN_POPULATE("srvUrl", "", CopyURL, &gCfg.server_url);
        if(extractString("enableDHCP", "") == make_pair(true, string("on"))){
            gCfg.dhcp = true;
        }else{
            gCfg.dhcp = false;
            CHECK_THEN_POPULATE("deviceIP4", "", dotsNotation2IPv4, &gCfg.ipv4);
            CHECK_THEN_POPULATE("deviceMask4", "", dotsNotation2IPv4, &gCfg.mask_v4);
            CHECK_THEN_POPULATE("deviceGW4", "", dotsNotation2IPv4, &gCfg.gw_v4);
            CHECK_THEN_POPULATE("deviceIP6", "", CIDR2IPv6, &gCfg.ipv6);
            CHECK_THEN_POPULATE("deviceIP6", "", CIDR2PrefixLen, &gCfg.prefixLen);
            CHECK_THEN_POPULATE("deviceGW6", "", CIDR2IPv6, &gCfg.gw_v6);
            CHECK_THEN_POPULATE("deviceDNS1", "", CopyURL, &gCfg.dns1);
            if(gCfg.ipv4.s_addr == 0 && memcmp(&gCfg.ipv6, &IP6_ANY, sizeof(in6_addr) == 0)) {
                return QrCodeNeither4Nor6;
            }
        }
        ofstream jsonDump("cfg_dump.json");
        jsonDump << json;
        jsonDump.close();
        return QrCodeParseOK;
    }
    return QrCodeContentErr;
}

int ExtractConfig(void* rawImage, size_t len, int height, int width)
{
    using namespace zbar;
    int ret = QrCodeNotFound;
    // create a reader
    ImageScanner scanner;

    // configure the reader
    scanner.set_config(ZBAR_NONE, ZBAR_CFG_ENABLE, 1);

    // wrap image data
    Image image(width, height, "Y800", rawImage, len);

    // scan the image for barcodes
    int n = scanner.scan(image);

    // extract results
    for(Image::SymbolIterator symbol = image.symbol_begin();
        symbol != image.symbol_end();
        ++symbol) {
        // do something useful with results
        printf("decoded %s symbol '%s'\n", symbol->get_type_name().c_str(), symbol->get_data().c_str());
        ret = ParseJSON(symbol->get_data());
        if(ret == QrCodeContentErr) // may be an irrelevant QR code on screen
            continue;
        break;
    }

    // clean up
    image.set_data(NULL, 0);
    return ret;
}

static std::ostream &operator<<(std::ostream &os, in6_addr const &m) {
    char buf[INET6_ADDRSTRLEN];
    auto ptr = inet_ntop(AF_INET6, &m, buf, INET6_ADDRSTRLEN);
    return ptr ? (os << ptr) : os;
}

int ApplyConfig()
{
    std::ofstream ifupdown(IFUPDOWN_CONFIG_FILE);
    if(!ifupdown)
        return -1;
    ifupdown << "iface eth0 inet ";
    if(gCfg.dhcp)
        ifupdown << "dhcp" << std::endl;
    else if(gCfg.ipv4.s_addr != 0){
        ifupdown << "static" << std::endl
            << "\taddress " << inet_ntoa(gCfg.ipv4) << '\n'
            << "\tnetmask " << inet_ntoa(gCfg.mask_v4) << '\n'
            << "\tgateway " << inet_ntoa(gCfg.gw_v4) << '\n';
    }else{
        ifupdown << "manual" << std::endl;
    }
    if(!gCfg.dns1.empty() && gCfg.dns1.find(':') == std::string::npos) // v4 DNS
        ifupdown << "\tdns-nameservers " << gCfg.dns1 << '\n';

    ifupdown << "iface eth0 inet6 ";
    if(memcmp(&gCfg.ipv6, &IP6_ANY, sizeof(in6_addr)) != 0){
        ifupdown << "static" << std::endl
            << "\taddress " << gCfg.ipv6 << '/' << gCfg.prefixLen << '\n'
            << "\tgateway " << gCfg.gw_v6 << '\n';
    }else{
        ifupdown << "auto" << std::endl;
    }
    if(!gCfg.dns1.empty() && gCfg.dns1.find(':') != std::string::npos) // v6 DNS
        ifupdown << "\tdns-nameservers " << gCfg.dns1 << '\n';
    ifupdown.close();

    system("echo 'configure file is:';cat " IFUPDOWN_CONFIG_FILE);
    system("ifdown eth0");
    system("ifup eth0");
    return 0;
}

#ifdef TEST_QRCODE

int main(int argc, char const *argv[])
{
    int screen_height = 1080, screen_width = 1920;
    size_t len = screen_width*screen_height;
    char* image_captured = new char[len];
    
    FILE* fdbgimg = fopen("/tmp/captured.bin", "rb");
    fread(image_captured, 1, screen_width*screen_height, fdbgimg);
    fclose(fdbgimg);

    int ret = ExtractConfig(image_captured, len, screen_height, screen_width);
    printf("ExtractConfig = %d\n", ret);
    if(ret == QrCodeParseOK)
        ApplyConfig();

    delete[] image_captured;
    return 0;
}

#endif