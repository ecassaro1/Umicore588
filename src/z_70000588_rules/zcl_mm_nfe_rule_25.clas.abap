CLASS zcl_mm_nfe_rule_25 DEFINITION
  PUBLIC
  INHERITING FROM zcl_mm_nfe_rule_gen
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    ALIASES:
        validate FOR zif_mm_nfe_rule~validate.
    METHODS:
      validate REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_nfe_rule_25 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Ler o valor do campo da CDS ZZ1_MM_CONVERT_UNID_MED - UNIDADEMEDIDAXML,
*onde ZZ1_MM_CONVERT_UNID_MED - UNIDADEMEDIDASAP = uTrib
*
*Verificar se EKPO-MEINS = a CDS ZZ1_MM_CONVERT_UNID_MED - UNIDADEMEDIDASAP
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”.
*
*Mensagem de erro: “Unidade de Medida divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

***
* XML
    DATA v_fornec TYPE zz1_mm_convert_unid_med-fornecedor.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = gs_det-po-ekko-lifnr
      IMPORTING
        output = v_fornec.

    SELECT
        unidademedidasap
        INTO @DATA(v_unidademedidasap)
      FROM zz1_mm_convert_unid_med
      UP TO 1 ROWS
      WHERE unidademedidaxml = @gs_det-prod-ucom
        AND fornecedor = @v_fornec.
    ENDSELECT.

    IF ( v_unidademedidasap IS INITIAL ).
      SELECT
          unidademedidasap
          INTO @v_unidademedidasap
        FROM zz1_mm_convert_unid_med
        UP TO 1 ROWS
        WHERE unidademedidaxml = @gs_det-prod-ucom.
      ENDSELECT.
    ENDIF.

    IF ( v_unidademedidasap IS INITIAL ).
      v_unidademedidasap = gs_det-prod-ucom.
    ENDIF.

***
* PO
    DATA v_po_meins TYPE ekpo-meins.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input  = gs_det-po-ekpo-meins
      IMPORTING
        output = v_po_meins.


***
* XML vs PO
    IF ( v_unidademedidasap <> v_po_meins ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_unidademedidasap )
       iv_valorsap = CONV #( v_po_meins )
      ).
      RETURN.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
