CLASS zcl_mm_nfe_rule_23 DEFINITION
  PUBLIC
  INHERITING FROM zcl_mm_nfe_rule_gen
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    ALIASES:
        validate FOR zif_mm_nfe_rule~validate.
    METHODS:
      validate REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_nfe_rule_23 IMPLEMENTATION.
  METHOD validate.
*Se xPed = EKKO-EBELN, então:
*
*Caso tag CRT de <emit> seja 1, então mostrar no cabeçalho do app “dispensa pin”  no campo CRT
*
*Caso tag CRT de <emit> seja 2, então mostrar no cabeçalho do app “necessita pin”  no campo CRT
*
*Caso tag CRT de <emit> seja 3, então mostrar no cabeçalho do app “necessita pin”  no campo CRT


***
* This is not really a validation rule. It is really a field at header level (InfNFeEmitCrtPin).
* This rule is not mapped neither in the table or in the validator.
***

  ENDMETHOD.
ENDCLASS.
