CLASS zcl_mm_xml_helper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      clear_all,
      tables_fill.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_xml_helper IMPLEMENTATION.
  METHOD clear_all.
    DELETE FROM:
        ztmm_xml_hist_hd,
        ztmm_xml_hd_cod,
        ztmm_xml_hist_it,
        ztmm_xml_log,
        ztmm_log_erros,
        ztmm_xml_obs.
  ENDMETHOD.

  METHOD tables_fill.
    DELETE FROM:
      ztmm_xml_hist_hd,
      ztmm_xml_hist_it,
      ztmm_xml_regra.

    data t_regra type standard table of ztmm_xml_regra with default key.

    append
        value #(
            TAG_XML_HDR  =   '<EMIT>'
            TAG_XML_ITEM =   '<CNPJ>'
            CAMPO_SAP    =   'STCD1'
            STATUS_VALID =   'E'
            MESSAGE      =   'CNPJ do fornecedor incorreto'
        ) to t_regra.

    insert ztmm_xml_regra from table t_regra.
*
*    DATA t_hd TYPE STANDARD TABLE OF ztmm_xml_hist_hd WITH DEFAULT KEY.
*
*    APPEND
*        VALUE #(
*            chave = '31210916701716000156550230007821981057659437'
*            xml = '<tag1><tag11></tag11></tag1>'
*        )
*        TO t_hd.
*
*    INSERT ztmm_xml_hist_hd FROM TABLE t_hd.
*
*    DATA t_it TYPE STANDARD TABLE OF ztmm_xml_hist_it WITH DEFAULT KEY.
*
*    APPEND:
*        VALUE #(
*            chave = '31210916701716000156550230007821981057659437'
*            id = '1'
*        )
*        TO t_it,
*        VALUE #(
*            chave = '31210916701716000156550230007821981057659437'
*            id = '2'
*        )
*        TO t_it.
*
*
*    INSERT ztmm_xml_hist_it FROM TABLE t_it.
  ENDMETHOD.
ENDCLASS.
