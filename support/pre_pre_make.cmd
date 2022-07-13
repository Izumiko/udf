@echo # Generating $@ because of $?
@echo /* This file generated automatically. */ > udf_names.c
@echo /*          Do not modify.            */ >> udf_names.c
@echo #include "udf.h" >> udf_names.c
@echo #include "prop.h" >> udf_names.c
@echo #include "dpm.h" >> udf_names.c
@"${FLUENT_INC}\\ntbin\\win64\\sed.exe" -n "s/^ *\(DEFINE_[_A-Z]*(.*)\)/extern \1;/p" ${CSOURCES} >> udf_names.c
@echo __declspec(dllexport) UDF_Data udf_data[] = { >> udf_names.c
@"${FLUENT_INC}\\ntbin\\win64\\sed.exe" -n "s/^ *DEFINE_\([_A-Z]*\)( *\([_a-zA-Z0-9]*\).*)/\{\"\2\", (void (*)(void))\2, UDF_TYPE_\1\},/p" ${CSOURCES} >> udf_names.c
@echo }; >> udf_names.c
@echo __declspec(dllexport) int n_udf_data = sizeof(udf_data)/sizeof(UDF_Data); >> udf_names.c
@echo #include "version.h" >> udf_names.c
@echo __declspec(dllexport) void UDF_Inquire_Release(int *major, int *minor, int *revision) >> udf_names.c
@echo { >> udf_names.c
@echo   *major = RampantReleaseMajor; >> udf_names.c
@echo   *minor = RampantReleaseMinor; >> udf_names.c
@echo   *revision = RampantReleaseRevision; >> udf_names.c
@echo } >> udf_names.c
"${FLUENT_INC}\\ntbin\\win64\\resolve.exe" -udf ${CSOURCES} -head_file ud_io1.h