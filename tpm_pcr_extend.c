#include <tss/platform.h>
#include <tss/tss_typedef.h>
#include <tss/tss_structs.h>
#include <tss/tspi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define DATA_LEN  20

_Noreturn void usage(char *argv0) {
    fprintf(stderr, "Usage: %s <PCR> <data>\n", argv0);
    fprintf(stderr, "  where:\n");
    fprintf(stderr, "  <PCR>  - PCR number to extend with given data\n");
    fprintf(stderr, "  <data> - hex encoded, %d bytes data\n", DATA_LEN);
    exit(1);
}

int do_pcr_extend(int pcr, BYTE *data, size_t data_len) {
    TSS_RESULT ret;
    TSS_HCONTEXT context;
    TSS_HTPM tpm;
    BYTE *new_pcr_value;
    unsigned int new_pcr_value_len;

    assert(data_len == 20);

    ret = Tspi_Context_Create(&context);
    if (ret != TSS_SUCCESS) {
        fprintf(stderr, "ERROR: failed to get TSS context: %d\n", ret);
        return 1;
    }
    ret = Tspi_Context_Connect(context, NULL);
    if (ret != TSS_SUCCESS) {
        fprintf(stderr, "ERROR: failed to connect to TSS daemon: %d\n", ret);
        return 1;
    }
    ret = Tspi_Context_GetTpmObject(context, &tpm);
    if (ret != TSS_SUCCESS) {
        fprintf(stderr, "ERROR: failed to get TPM object: %d\n", ret);
        return 1;
    }
    ret = Tspi_TPM_PcrExtend(tpm, pcr, data_len, data, NULL /* event */,
            &new_pcr_value_len, &new_pcr_value);
    if (ret != TSS_SUCCESS) {
        fprintf(stderr, "ERROR: PCR extend fails with code %d\n", ret);
        return 1;
    }
    /* this will free new_pcr_value */
    Tspi_Context_Close(context);
    return 0;
}

int main(int argc, char **argv) {
    char data[DATA_LEN];
    int i;

    if (argc != 3)
        usage(argv[0]);
    if (strlen(argv[2]) != 2*DATA_LEN)
        usage(argv[0]);
    for (i = DATA_LEN - 1; i >= 0; i--) {
        data[i] = strtoul(argv[2]+i*2, NULL, 16);
        argv[2][i*2] = '\0';
    }

    return do_pcr_extend(atoi(argv[1]), (BYTE*)data, DATA_LEN);
}
