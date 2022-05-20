CLASS zcl_mm_nfe_rule_15 DEFINITION
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



CLASS zcl_mm_nfe_rule_15 IMPLEMENTATION.


  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Se <motDesICMS> for igual a 7, não validar as condições de base e alíquota de ICMS(ZIRD e ZCRD abaixo)
*
*Se vICMSDeson está preenchida E vICMSDeson > 0, então
*
*Ler condições PBXX, ZIRD, ZCRD do item do pedido:
*
*Ler campo KNUMV da tabela EKKO, onde EKKO-EBELN = xPed
*
*Ler campos KSCHL, KWERT da tabela PRCD_ELEMENTS, onde PRCD_ELEMENTS-KNUMV = EKKO-KNUMV E PRCD_ELEMENTS-KAPPL = ‘M’ E PRCD_ELEMENTS-KSCHL IN (‘ZIRD’, ZCRD’, ‘PBXX’)
*
*Verificar se o valor do campo KWERT para ZIRD ou ZCRD é igual a vICMSDeson.
*
*Se houver divergência, então:
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”.
*
*Mensagem de erro: “Valor ICMS Desonerado divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

* Comentando para checagem futura
*    DATA(v_icms_motdesicms) = char_val_2_dec( CONV #( gs_det-imposto-icms-motdesicms ) ).
*    CHECK ( v_icms_motdesicms <> '7' ).

*    DATA(v_icms_vicmsdeson) = char_val_2_dec( CONV #( gs_det-imposto-icms-vicmsdeson ) ).
*    CHECK ( v_icms_vicmsdeson > 0 ).
*
**   DATA(v_zird) = get_prcd_element( 'ZIRD' )-kwert. "Trocou para ZIIC
**   DATA(v_zcrd) = get_prcd_element( 'ZCRD' )-kwert. "Trocou para ZCIC
*    DATA(v_ziic) = get_prcd_element( 'ZIIC' )-kwert.
*    DATA(v_zcic) = get_prcd_element( 'ZCIC' )-kwert.
**   DATA(v_pbxx) = get_prcd_element( 'PBXX' )-kwert.
*
*    v_ziic = abs( v_ziic ).
*    v_zcic = abs( v_zcic ).
*
*    IF ( v_ziic <> 0 ).
*      IF ( v_icms_vicmsdeson <> v_ziic ).
*        rs_error = fill_error_entity(
*         iv_valorxml = CONV #( v_icms_vicmsdeson )
*         iv_valorsap = CONV #( v_ziic )
*        ).
*      ENDIF.
*      RETURN.
*    ENDIF.
*
*    IF ( v_zcic <> 0 ).
*      IF ( v_icms_vicmsdeson <> v_zcic ).
*        rs_error = fill_error_entity(
*         iv_valorxml = CONV #( v_icms_vicmsdeson )
*         iv_valorsap = CONV #( v_zcic )
*        ).
*      ENDIF.
*      RETURN.
*    ENDIF.

*V2
    DATA(v_icms_vicmsdeson) = char_val_2_dec( CONV #( gs_det-imposto-icms-vicmsdeson ) ).
    CHECK ( NOT v_icms_vicmsdeson IS INITIAL ).

    DATA v_value_xml TYPE p DECIMALS 2.
    DATA v_value_sap TYPE p DECIMALS 2.

    v_value_xml = v_icms_vicmsdeson.
    v_value_sap = gs_det-vlrs-icms-amnt.

    IF ( v_value_xml <> v_value_sap ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_value_xml )
       iv_valorsap = CONV #( v_value_sap )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
