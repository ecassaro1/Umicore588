interface ZIF_MM_EFD_COIMPA
  public .


  class-methods WRITE_NF
    importing
      !IV_ACCESSKEY type EDOC_ACCESSKEY
      value(IV_TEST) type ABAP_BOOL optional
    returning
      value(RT_MESSAGES) type BAPIRET2_TAB .
  class-methods _CHECK_PO
    importing
      !IV_ACCESSKEY type EDOC_ACCESSKEY
      value(IV_TEST) type ABAP_BOOL optional
    returning
      value(RT_MESSAGE) type BAPIRET2_TAB .
  class-methods _CHECK_OTHER_ENTRIES
    importing
      !IT_XML_HIST_IT type ZTMM_XML_HIST_TT
      value(IV_ACCESSKEY) type EDOC_ACCESSKEY optional
      value(IV_TEST) type ABAP_BOOL optional
    returning
      value(RT_MESSAGE) type BAPIRET2_TAB .
  class-methods _FILL_NFE_UPDATE_ACTIVE
    importing
      !IV_DOCNUM type J_1BNFDOC-DOCNUM
      value(IV_ACCESSKEY) type EDOC_ACCESSKEY optional
      value(IV_TEST) type ABAP_BOOL optional
      value(IT_XML_HIST_IT) type ZTMM_XML_HIST_TT optional
    returning
      value(RT_MESSAGE) type BAPIRET2_TAB .
  class-methods _CHECK_NF_DONE
    importing
      !IV_ACCESSKEY type EDOC_ACCESSKEY
    returning
      value(RT_MESSAGE) type BAPIRET2_TAB .
  class-methods _FILL_BAPI_DATA
    importing
      !IV_ACCESSKEY type EDOC_ACCESSKEY
      value(IV_TEST) type ABAP_BOOL optional
    returning
      value(RT_MESSAGES) type BAPIRET2_TAB .
  class-methods _MESSAGE_TEXT_BUILD
    importing
      !IV_MSGID type SYMSGID
      !IV_MSGNR type SYMSGNO
    returning
      value(MESSAGE_TEXT_OUTPUT) type CHAR75 .
endinterface.
