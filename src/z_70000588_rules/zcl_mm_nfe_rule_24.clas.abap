CLASS zcl_mm_nfe_rule_24 DEFINITION
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



CLASS zcl_mm_nfe_rule_24 IMPLEMENTATION.


  METHOD validate.

**Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
**
**Verificar se EKPO-NETPR = vUnTrib.
**
**Se houver divergência, então:
**
**então
**ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”.
**
**Mensagem de erro: “Preço Unitário divergente”
**
**Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.
**
**Valor exato por item com 2 casas decimais
*
*
*
*    DATA(v_vuntrib) = CONV bprei( gs_det-prod-vuntrib ).
*
*    IF ( v_vuntrib <> gs_det-po-ekpo-netpr ).
*      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( v_vuntrib )
*       iv_valorsap = CONV #( gs_det-po-ekpo-netpr )
*      ).
*      RETURN.
*    ENDIF.

*############################################################################################
*V2

*Trazendo o preço Unit. Pedido de EKPO-NETPR, corrigir da seguinte forma:
*Com o nº do pedido pegar o valor de EKKO-KNUMV, com o valor
*coletado buscar na PRCD_ELEMENTS sendo PRCD_ELEMENTS-KNUMV = valor
*de EKKO-KNUMV e buscar o valor de PRCD_ELEMENTS-KBETR sendo
*PRCD_ELEMENTS-KSCHL = PBXX e dividir o valor de PRCD_ELEMENTS-KBETR
*por PRCD_ELEMENTS-KBETR PRCD_ELEMENTS-KPEIN e mostrar na tela duas
*casas decimais após a virgula


*    TRY.
*        DATA(v_pbxx) =
*            gs_det-po-t_prcd_elements[
*                kappl = 'M'
*                kschl = 'PBXX'
*            ]-kbetr.
*      CATCH cx_sy_itab_line_not_found.
*    ENDTRY.
*    TRY.
*        DATA(v_prcd) =
*            gs_det-po-t_prcd_elements[
*                kappl = 'M'
*                kschl = 'PRCD'
*            ]-kbetr.
*      CATCH cx_sy_itab_line_not_found.
*    ENDTRY.
*
*    DATA: v_ponetpr TYPE p DECIMALS 2.
*    IF ( v_prcd <> 0 ).
*      v_ponetpr =
*         ( v_pbxx / v_prcd ).
*    ELSE.
**     v_ponetpr = v_pbxx.
*      TRY.
*          DATA(v_pbxx_kpein) =
*              gs_det-po-t_prcd_elements[
*                  kappl = 'M'
*                  kschl = 'PBXX'
*              ]-kpein.
*
*          v_ponetpr = ( v_pbxx / v_pbxx_kpein ).
*        CATCH cx_sy_itab_line_not_found.
*          v_ponetpr = ( v_pbxx / gs_det-po-ekpo-peinh ).
*      ENDTRY.
*
*    ENDIF.

*    DATA(v_vuncom) = CONV bprei( gs_det-prod-vuncom ).
*    DATA v_ponetpr TYPE p DECIMALS 2.
*    v_ponetpr = gs_det-vlrs-netpr-amnt.
*
*    IF ( v_vuncom <> v_ponetpr ).
*      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( v_vuncom )
*       iv_valorsap = CONV #( v_ponetpr )
*      ).
*      RETURN.
*    ENDIF.


*V3
    DATA v_value_xml TYPE p DECIMALS 2.
    DATA v_value_sap TYPE p DECIMALS 2.

    DATA(v_vuncom) = CONV bprei( gs_det-prod-vuncom ).
    v_value_xml = v_vuncom.
    v_value_sap = gs_det-vlrs-netpr-amnt.

    IF ( v_value_xml <> v_value_sap ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_value_xml )
       iv_valorsap = CONV #( v_value_sap )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
