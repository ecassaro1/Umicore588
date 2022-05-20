***
* The eDoc entity has its data taken from the XML string. For this reason the majority of
* the attributes are filled as virtual element. This is the place where the header attributes
* are filled.
**
* Jan/2022
* Eric Cassaro (Numen)
***
class ZCL_MM_EDOC_ATTRS definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
protected section.

  methods FIRST_EKKO_RETRIEVE
    importing
      !IS_NFE_DATA type ZCL_MM_NFE=>Y_NFE_DATA
    returning
      value(RS_EKKO) type EKKO .
  methods CONV_DATE_OUT
    importing
      !IV_DATE_IN type CHAR10
    returning
      value(RV_DATE_OUT) type CHAR10 .
  methods BUILD_EKKOUSER
    importing
      !IS_INFNFE type ZCL_MM_NFE=>Y_NFE_DATA-INFNFE
      !IS_ORIG type ZCDSMM_C_EDOC
    returning
      value(RS_ORIG) type ZCDSMM_C_EDOC .
  methods EVAL_STATUSVALID
    importing
      !IV_ACCESSKEY type ZCDSMM_C_EDOC-ACCESSKEY
      !IV_EDOCGUID type ZCDSMM_C_EDOC-EDOCGUID
    returning
      value(RV_STATUSVALID) type ZCDSMM_C_EDOC-STATUSVALID .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_EDOC_ATTRS IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
*
    DATA:
      t_orig       TYPE STANDARD TABLE OF zcdsmm_c_edoc WITH DEFAULT KEY.

    MOVE-CORRESPONDING it_original_data TO t_orig.

    LOOP AT t_orig REFERENCE INTO DATA(r_orig).
      DATA(o_nfe) = NEW zcl_mm_nfe( r_orig->accesskey ).

      DATA(s_nfe_data) =
        o_nfe->get_nfe_data(
            iv_full = abap_true
            iv_with_ref = abap_true
        ).
*      DATA(s_ref_nfe_data) = o_nfe->get_ref_nfe_data( ).

      r_orig->infnfeidecuf = s_nfe_data-infnfe-ide-cuf.
      r_orig->infnfeidetpnf = s_nfe_data-infnfe-ide-tpnf.
      r_orig->infnfeidenatop = s_nfe_data-infnfe-ide-natop.
      r_orig->infnfeidefinnfe = s_nfe_data-infnfe-ide-finnfe.
      r_orig->infnfeidedhemi = s_nfe_data-infnfe-ide-dhemi.
      r_orig->infnfeemitxnome = s_nfe_data-infnfe-emit-xnome.
      r_orig->infnfeemitcnpj = s_nfe_data-infnfe-emit-cnpj.
      r_orig->infnfeemitie = s_nfe_data-infnfe-emit-ie.
      r_orig->infnfeemitenderemitxbairro = s_nfe_data-infnfe-emit-enderemit-xbairro.
      r_orig->infnfeemitenderemitxlgr = s_nfe_data-infnfe-emit-enderemit-xlgr.
      r_orig->infnfeemitenderemitnro = s_nfe_data-infnfe-emit-enderemit-nro.
      r_orig->infnfeemitenderemitxcpl = s_nfe_data-infnfe-emit-enderemit-xcpl.
      r_orig->infnfeemitenderemitcep = s_nfe_data-infnfe-emit-enderemit-cep.
      r_orig->infnfeemitenderemitcmun = s_nfe_data-infnfe-emit-enderemit-cmun.
      r_orig->infnfeemitenderemitxmun = s_nfe_data-infnfe-emit-enderemit-xmun.
      r_orig->infnfeemitenderemituf = s_nfe_data-infnfe-emit-enderemit-uf.
      r_orig->infnfeemitenderemitcpais = s_nfe_data-infnfe-emit-enderemit-cpais.
      r_orig->infnfeemitenderemitxpais = s_nfe_data-infnfe-emit-enderemit-xpais.
      r_orig->infnfedestxnome = s_nfe_data-infnfe-dest-xnome.
      r_orig->infnfedestcnpj = s_nfe_data-infnfe-dest-cnpj.
      r_orig->infnfedestie = s_nfe_data-infnfe-dest-ie.

      r_orig->* =
        build_ekkouser(
            is_infnfe = s_nfe_data-infnfe
            is_orig = r_orig->*
        ).

      r_orig->infnfeidenfrefrefnfe = s_nfe_data-infnfe-ide-nfref-refnfe.
*      r_orig->infnfeidenfrefnnf = s_nfe_data-infnfe-ide-nfref-nnf.
      r_orig->infnfeidenfrefnnf = s_nfe_data-ref-nfenum.
      r_orig->infnfedestenderdestisuf = s_nfe_data-infnfe-dest-isuf.
      r_orig->infnfedestemail = s_nfe_data-infnfe-dest-email.
      r_orig->infnfetranspmodfrete = s_nfe_data-infnfe-transp-modfrete.
      r_orig->infnfecobrdupdvenc =
        conv_date_out( CONV #( s_nfe_data-infnfe-cobr-dup-dvenc ) ).
      r_orig->infnfedestcrt = s_nfe_data-infnfe-emit-crt.
      r_orig->infnfetransptransportaxnome = s_nfe_data-infnfe-transp-transporta-xnome.
      r_orig->infnfetotalicmstotvnf = s_nfe_data-infnfe-total-icmstot-vnf.
      r_orig->infnfeidedhemi =
        conv_date_out( CONV #( s_nfe_data-infnfe-ide-dhemi ) ).
*      r_orig->infnfeemitcrtpin =
*        COND #(
*            WHEN r_orig->pin IS NOT INITIAL
*                THEN r_orig->pin
*            ELSE
*                SWITCH #(
*                    s_nfe_data-infnfe-emit-enderemit-uf
*                    WHEN 'AM' THEN '1'
*                    ELSE s_nfe_data-infnfe-emit-crt
*                )
*        ).
      r_orig->infnfetransptransportacnpj = s_nfe_data-infnfe-transp-transporta-cnpj.

*      r_orig->refinfnfeidedhemi =
*        conv_date_out( CONV #( s_ref_nfe_data-infnfe-ide-dhemi ) ).
      r_orig->refinfnfeidedhemi =
        |{ s_nfe_data-ref-pstdat+6(2) }/{ s_nfe_data-ref-pstdat+4(2) }/{ s_nfe_data-ref-pstdat(4) }|.

*      r_orig->refinfnfetotalicmstotvnf = s_ref_nfe_data-infnfe-total-icmstot-vnf.
      r_orig->refinfnfetotalicmstotvnf = s_nfe_data-ref-nftot.

      r_orig->refdocnum = s_nfe_data-ref-docnum.

      r_orig->infnfeemitenderemitfone = s_nfe_data-infnfe-emit-enderemit-fone.

      r_orig->poinco1 = first_ekko_retrieve( s_nfe_data )-inco1.

**StatusValid
*      r_orig->statusvalid =
*        eval_statusvalid(
*            iv_accesskey = r_orig->accesskey
*            iv_edocguid  = r_orig->edocguid
*        ).
* moved to pure CDS evaluation

    ENDLOOP.

    MOVE-CORRESPONDING t_orig TO ct_calculated_data.
*
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    CASE iv_entity.
      WHEN 'ZCDSMM_C_EDOC'.
        APPEND 'EDOCGUID' TO et_requested_orig_elements.
        APPEND 'PIN' TO et_requested_orig_elements.
    ENDCASE.
  ENDMETHOD.


  METHOD first_ekko_retrieve.
*EKKO must be retrieved from any of the NFE items
    READ TABLE is_nfe_data-infnfe-det
        INTO DATA(s_det1)
        INDEX 1.
    CHECK ( NOT s_det1 IS INITIAL ).

    rs_ekko = s_det1-po-ekko.
  ENDMETHOD.


  METHOD conv_date_out.
    CHECK ( NOT iv_date_in IS INITIAL ).

    rv_date_out =
              |{ iv_date_in+8(2) }|
          &&  |/|
          &&  |{ iv_date_in+5(2) }|
          &&  |/|
          &&  |{ iv_date_in(4) }|.
  ENDMETHOD.


  METHOD build_ekkouser.

    rs_orig = is_orig.


    TYPES:
      BEGIN OF y_user,
        ernam TYPE ekko-ernam,
      END OF y_user.
    DATA t_user TYPE STANDARD TABLE OF y_user WITH DEFAULT KEY.


    LOOP AT is_infnfe-det
      INTO DATA(s_det1).

***
* check to not include the same user twice
      READ TABLE t_user
        TRANSPORTING NO FIELDS
        WITH KEY ernam = s_det1-po-ekko-ernam.
      CHECK ( NOT sy-subrc IS INITIAL ).
      APPEND
        VALUE #(
            ernam = s_det1-po-ekko-ernam
        ) TO t_user.
*
***

      rs_orig-ekkouser =
              |{ rs_orig-ekkouser }|
          &&  |{
                  COND char1(
                          WHEN rs_orig-ekkouser IS NOT INITIAL THEN '/'
                          ELSE ''
                  )
           }|
          &&  |{ s_det1-po-ekko-ernam }|.

      SELECT SINGLE
              nametext
            FROM zcdsmm_i_user
            WHERE bname = @s_det1-po-ekko-ernam
            INTO @DATA(v_nametext).

      rs_orig-ekkousername =
              |{ rs_orig-ekkousername }|
          &&  |{
                  COND char1(
                          WHEN rs_orig-ekkousername IS NOT INITIAL THEN '/'
                          ELSE ''
                  )
           }|
          &&  |{ v_nametext }|.
    ENDLOOP.

  ENDMETHOD.


  METHOD eval_statusvalid.
*######################################################
* OBSOLETE
*######################################################

*default is from I_XML
    SELECT SINGLE
        statusvalid
      FROM zcdsmm_i_xml_hist_hd
      WHERE chave = @iv_accesskey
      INTO @rv_statusvalid.


*check if was cancelled
    SELECT
          process,
          proc_status
      INTO TABLE @DATA(t_stat)
      FROM edocumenthistory
      WHERE edoc_guid = @iv_edocguid.

    READ TABLE t_stat
        TRANSPORTING NO FIELDS
        WITH KEY process = 'BRCANCEL'.
    IF ( NOT sy-subrc IS INITIAL ). "has no BRCANCEL process
      READ TABLE t_stat
          TRANSPORTING NO FIELDS
          WITH KEY proc_status = 'STA_CANC'.
    ENDIF.
    CHECK ( sy-subrc IS INITIAL ). "has STA_CANC status

*    READ TABLE t_stat
*        TRANSPORTING NO FIELDS
*        WITH KEY proc_status = 'STA_AUTH'.
*    CHECK ( NOT sy-subrc IS INITIAL ). "has no STA_AUTH
*
*    READ TABLE t_stat
*        TRANSPORTING NO FIELDS
*        WITH KEY proc_status = 'NFE_AUTH'.
*    CHECK ( NOT sy-subrc IS INITIAL ). "has no NFE_AUTH

*it was cancelled, because has status CANC and no AUTH
    rv_statusvalid = 'C'.

  ENDMETHOD.
ENDCLASS.
