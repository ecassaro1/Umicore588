CLASS zcl_mm_nfe_rule_28 DEFINITION
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



CLASS zcl_mm_nfe_rule_28 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKKO-EBELN, então:
*
*Ler o campo ZBD1T da tabela EKKO onde EKKO-EBELN = xPed.
*
*Calcular a data de vencimento da fatura como dhEmi + EKKO-ZBD1T.
*
*Verificar se a data de pagamento calculada = dVenc.
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”.
*
*Mensagem de erro: “Data de vencimento divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

    DATA(s_nfe_data) = go_nfe->get_nfe_data(  ).

    CHECK:
        ( strlen( s_nfe_data-infnfe-ide-dhemi )         >= 10 ),
        ( strlen( s_nfe_data-infnfe-cobr-dup-dvenc )    >= 10 ).

    DATA:
      v_xml_dhemi TYPE sy-datum,
      v_xml_dvenc TYPE sy-datum.

    v_xml_dhemi =
        |{ s_nfe_data-infnfe-ide-dhemi(4) }{ s_nfe_data-infnfe-ide-dhemi+5(2) }{ s_nfe_data-infnfe-ide-dhemi+8(2) }|.

    v_xml_dvenc =
        |{ s_nfe_data-infnfe-cobr-dup-dvenc(4) }{ s_nfe_data-infnfe-cobr-dup-dvenc+5(2) }{ s_nfe_data-infnfe-cobr-dup-dvenc+8(2) }|.

    DATA:
      v_sap_dvenc TYPE sy-datum,
      v_days      TYPE t5a4a-dlydy.

    v_days = CONV #( gs_det-po-ekko-zbd1t ).

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = v_xml_dhemi
        days      = v_days
        months    = '00'
        years     = '00'
        signum    = '+'
      IMPORTING
        calc_date = v_sap_dvenc.

***
    IF ( v_xml_dvenc <> v_sap_dvenc ).
      DATA:
        v_xml_dvenc_out TYPE char10,
        v_sap_dvenc_out TYPE char10.

      WRITE:
        v_xml_dvenc TO v_xml_dvenc_out,
        v_sap_dvenc TO v_sap_dvenc_out.

      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_xml_dvenc_out )
       iv_valorsap = CONV #( v_sap_dvenc_out )
      ).
      RETURN.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
