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

// low 32-bit from IPv6 address
#define EXTRACT_V4MAPPED(addr) ((in_addr_t)((addr).__in6_u.__u6_addr32[3]))

static const in6_addr IP6_ANY = IN6ADDR_ANY_INIT;
static struct{
    struct in_addr ipv4, mask_v4, gw_v4;
    struct in6_addr gw_v6;
    struct in6_addr ipv6;
    struct in6_addr dns1;
    uint8_t prefixLen;
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

int dotsNotation2IPv4(const std::string &ip, struct in_addr *field)
{
    if(ip.empty()){
        field->s_addr = INADDR_ANY;
        return QrCodeParseOK;
    }
    if(inet_aton(ip.c_str(), field))
        return QrCodeParseOK;
    return QrCodeInvalidIPv4;
}
int CIDR2IPv6(const std::string &ip, struct in6_addr *field)
{
    if(ip.empty()){
        *field = in6_addr(IN6ADDR_ANY_INIT);
        return QrCodeParseOK;
    }
    auto slash = std::find(ip.begin(), ip.end(), '/');
    if(inet_pton(AF_INET6, std::string(ip.begin(), slash).c_str(), field))
        return QrCodeParseOK;
    return QrCodeInvalidIPv6;
}
int CIDR2PrefixLen(const std::string &ip, uint8_t *len)
{
    if(ip.empty()){
        *len = 0;
        return QrCodeParseOK;
    }
    auto slash = find(ip.begin(), ip.end(), '/');
    if(slash == ip.end())
        return QrCodeInvalidIPv6;
    return 1 == sscanf(std::string(slash+1, ip.end()).c_str(), "%hhu", len) ?
            QrCodeParseOK :
            QrCodeInvalidIPv6;
}
int CopyDNS(const std::string &ip, struct in6_addr *field)
{
    if(CIDR2IPv6(ip, field) == QrCodeParseOK)
        return QrCodeParseOK;
    struct in_addr v4;
    if(dotsNotation2IPv4(ip, &v4) == QrCodeParseOK){
        // IPv4-Mapped IPv6 Address 
        field->__in6_u.__u6_addr32[0] = 0;
        field->__in6_u.__u6_addr32[1] = 0;
        field->__in6_u.__u6_addr32[2] = htonl (0xffff);
        field->__in6_u.__u6_addr32[3] = v4.s_addr;
        return QrCodeParseOK;
    }
    return QrCodeInvalidDNS;
}
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

        memset(&gCfg, 0, sizeof(gCfg));
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
            CHECK_THEN_POPULATE("deviceDNS1", "", CopyDNS, &gCfg.dns1);
            if(gCfg.ipv4.s_addr == 0 && memcmp(&gCfg.ipv6, &in6addr_any, sizeof(in6_addr)) == 0) {
                return QrCodeNeither4Nor6;
            }
        }
        ofstream jsonDump("config.json");
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
    if(IN6_IS_ADDR_V4MAPPED(&gCfg.dns1)){ // v4 DNS
        struct in_addr v4;
        v4.s_addr = EXTRACT_V4MAPPED(gCfg.dns1);
        ifupdown << "\tdns-nameservers " << inet_ntoa(v4) << '\n';
    }

    ifupdown << "iface eth0 inet6 ";
    if(memcmp(&gCfg.ipv6, &in6addr_any, sizeof(in6_addr)) != 0){
        ifupdown << "static" << std::endl
            << "\taddress " << gCfg.ipv6 << '/' << (int)gCfg.prefixLen << '\n'
            << "\tgateway " << gCfg.gw_v6 << '\n';
    }else{
        ifupdown << "auto" << std::endl;
    }
    if(!IN6_IS_ADDR_V4MAPPED(&gCfg.dns1)) // v6 DNS
        ifupdown << "\tdns-nameservers " << gCfg.dns1 << '\n';
    ifupdown.close();

    system("echo 'configure file is:';cat " IFUPDOWN_CONFIG_FILE);
    system("ifdown --force --ignore-errors eth0");
    system("ifup eth0");
    return 0;
}

const char* QrCodeErrorMessage(int err)
{
    switch(err){
        case QrCodeParseOK:
            return "Success";
        case QrCodeNotFound:
            return "QR Code Not Found";
        case QrCodeContentErr:
            return "Unrecognized QR Code";
        case QrCodeInvalidDNS:
            return "Invalid DNS Config";
        case QrCodeInvalidIPv4:
            return "Invalid IPv4 Format";
        case QrCodeInvalidIPv6:
            return "Invalid IPv6 Format";
        case QrCodeNeither4Nor6:
            return "Both IPv4 and IPv6 are Unconfigured";
        default:
            return "Unknown Error";
    }
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