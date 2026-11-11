# RERAM_CIM_32x32

The `RERAM_CIM_32x32` primitive implements an interface to the `sky130_bmlabs_reram__cim32x32` ReRAM IP.

![RERAM_CIM_32x32](images/svg/RERAM_CIM_32x32.svg){align=center}

## Signals

| Name          | Direction | Width | Description              |
|---------------|-----------|-------|--------------------------|
| CLK           | input     | 1     |                          |
| RST           | input     | 1     |                          |
| CMD_VALID     | input     | 1     |                          |
| CMD_READY     | input     | 1     |                          |
| MODE          | output    | 2     |                          |
| ROW_INDEX     | input     | 5     |                          |
| COL_INDEX     | output    | 5     |                          |
| PWM_DATA      | output    | 8     |                          |
| COMPUTE_LAST  | output    | 1    |                          |
| COMPUTE_ALL_COLUMNS | output    | 1    |                          |
| BUSY          | output    | 1    |                          |
| COMMAND_ACCEPTED | input     | 1    |                          |
| COMPUTE_PENDING | output    | 1    |                          |
| ERROR         | output    | 3    |                          |
| ERROR_VALID   | output    | 1    |                          |
| OPERATION_DONE | output    | 1    |                          |
| PROGRAM_READBACK_ACTIVE | input     | 1    |                          |
| RESULT_VALID  | output    | 1    |                          |
| RESULT_READY  | output    | 1    |                          |
| RESULT_DATA   | output    | 21    |                          |
| RESULT_LAST   | output    | 1    |                          |

## Attributes

| Name          | Width | Description              |
|---------------|-------|--------------------------|
| TARGET_SET1   | 16    |                          |
| TARGET_SET2   | 16    |                          |
| TARGET_RESET1 | 16    |                          |
| TARGET_RESET2 | 16    |                          |
| NO_OF_CLK_CYCLES | 10    |                          |
| COUNTER_VALUE | 10    |                          |
| TDC_TIME_OUT  | 7     |                          |
| TDC_DEAD_TIME | 2     |                          |
