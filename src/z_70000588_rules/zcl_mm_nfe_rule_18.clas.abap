CLASS zcl_mm_nfe_rule_18 DEFINITION
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



CLASS zcl_mm_nfe_rule_18 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Se vICMSDeson > 0 OU estiver preenchido, então:
*
*Selecionar ZTMM_XML_R_CFOP-MATORG, ZTMM_XML_R_CFOP-MATUSE, ZTMM_XML_R_CFOP-MWSKZ onde ZTMM_XML_R_CFOP-CFOP = CFOP E ZTMM_XML_R_CFOP-ICMS_DESONERADO = X
*
*Verificar se ZTMM_XML_R_CFOP-MATORG = EKPO-J_1BMATORG E ZTMM_XML_R_CFOP-MATUSE = EKPO-J_1BMATUSE E ZTMM_XML_R_CFOP-MWSKZ = EKPO-MWSKZ
*
*Mensagem de erro :”Regra de CFOP divergente”.
*
*Se vICMSDeson = 0 OU estiver vazio, então:
*
*Selecionar ZTMM_XML_R_CFOP-MATORG, ZTMM_XML_R_CFOP-MATUSE, ZTMM_XML_R_CFOP-MWSKZ onde ZTMM_XML_R_CFOP-CFOP = CFOP E ZTMM_XML_R_CFOP-ICMS_DESONERADO = vazio
*
*Verificar se ZTMM_XML_R_CFOP-MATORG = EKPO-J_1BMATORG E ZTMM_XML_R_CFOP-MATUSE = EKPO-J_1BMATUSE E ZTMM_XML_R_CFOP-MWSKZ = EKPO-MWSKZ
*
*Se houver diferença, então
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”
*
*Mensagem de erro: “Regra de CFOP divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

    DATA(v_deson) =
        COND #(
            WHEN ( gs_det-imposto-icms-vicmsdeson > 0 )
            THEN abap_true
            ELSE abap_false
        ).

    SELECT SINGLE
        *
      INTO @DATA(s_xml_cfop)
      FROM ztmm_xml_r_cfop
      WHERE cfop = @gs_det-prod-cfop
        AND icms_desonerado = @v_deson
        AND matuse = @gs_det-po-ekpo-j_1bmatuse
        AND mwskz  = @gs_det-po-ekpo-mwskz.

*    IF ( s_xml_cfop-matorg <> gs_det-po-ekpo-j_1bmatorg ).
*      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( s_xml_cfop-matorg )
*       iv_valorsap = CONV #( gs_det-po-ekpo-j_1bmatorg )
*      ).
*      RETURN.
*    ENDIF.

    CONCATENATE 'CFOP' gs_det-prod-cfop
                INTO DATA(lv_valorxml) SEPARATED BY space.

    CONCATENATE 'Util.Mat' gs_det-po-ekpo-j_1bmatuse
                '; IVA' gs_det-po-ekpo-mwskz
                INTO DATA(lv_valorsap) SEPARATED BY space.

    IF ( s_xml_cfop-matuse <> gs_det-po-ekpo-j_1bmatuse ).
      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( s_xml_cfop-matuse )
*       iv_valorsap = CONV #( gs_det-po-ekpo-j_1bmatuse )
       iv_valorxml = CONV #( lv_valorxml )
       iv_valorsap = CONV #( lv_valorsap )
      ).
      RETURN.
    ENDIF.

    IF ( s_xml_cfop-mwskz <> gs_det-po-ekpo-mwskz ).
      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( s_xml_cfop-mwskz )
*       iv_valorsap = CONV #( gs_det-po-ekpo-mwskz )
       iv_valorxml = CONV #( lv_valorxml )
       iv_valorsap = CONV #( lv_valorsap )
      ).
      RETURN.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
