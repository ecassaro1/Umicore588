***
* This is the interface for all the validation rules
* of the NFe XML Validator (zcl_mm_nfe_validator)
***

INTERFACE zif_mm_nfe_rule
  PUBLIC.
      METHODS:
        validate
          RETURNING VALUE(rs_error) TYPE ZCDSMM_I_LOG_ERROS.
ENDINTERFACE.
