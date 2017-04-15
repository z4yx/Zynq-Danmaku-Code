/*
* edid_load /dev/mem edid_p2214.bin 0xff210400
*
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
int main(int argc, char *argv[])
{
    struct stat status;
    int fd;
    int file;
    char *uiod = argv[1];
    char *filename = argv[2];
    void *ptr;
    size_t size;
    off_t offset = argc>3 ? strtoul(argv[3],0,0) : 0;
    long pa_sz = sysconf(_SC_PAGESIZE);
    /* Open the UIO device file */
    fd = open(uiod, O_RDWR);
    if (fd < 1) {
        perror(uiod);
        printf("Invalid UIO device file:%s.\n", uiod);
        return -1;
    }
    file = open(filename, O_RDWR);
    if (file < 1) {
        perror(filename);
        printf("Invalid input file:%s.\n", filename);
        return -1;
    }
    fstat(file, &status);
    printf("file size %d bytes\n", status.st_size);
    size = (status.st_size+pa_sz-1)/pa_sz*pa_sz;
    printf("mmap length %u bytes\n", size);
    /* mmap the UIO device */
    ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED,
               fd, offset);
    if((int)ptr == -1){
        perror("mmap");
        goto close_file;
    }
    printf("mmapped pointer: %p\n", ptr);
    for(off_t i=0; i<status.st_size;){
        char buf[128];
        size_t s = read(file, buf, sizeof(buf));
        if(s <= 0)
            break;
        memcpy((char*)ptr+i, buf, s);
        i += s;
    }
close_file:
    close(file);
    munmap(ptr, status.st_size);
    return 0;
}