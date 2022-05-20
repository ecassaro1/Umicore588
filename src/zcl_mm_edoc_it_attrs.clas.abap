***
* The eDoc entity has its data taken from the XML string. For this reason the majority of
* the attributes are filled as virtual element. This is the place where the item attributes
* are filled.
**
* Jan/2022
* Eric Cassaro (Numen)
***

CLASS zcl_mm_edoc_it_attrs DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES:
      if_sadl_exit,
      if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
    METHODS:
      get_poprod
        IMPORTING
          is_det           TYPE zcl_mm_nfe=>y_det
        RETURNING
          VALUE(rv_poprod) TYPE zcdsmm_c_edoc_it-poprod,

      conv_date_out
        IMPORTING
          iv_date_in         TYPE char10
        RETURNING
          VALUE(rv_date_out) TYPE char10.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_edoc_it_attrs IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.
*
    TYPES:
      BEGIN OF y_nfe,
        chave      TYPE edoc_accesskey,
        o_ref      TYPE REF TO zcl_mm_nfe,
        s_nfe_data TYPE zcl_mm_nfe=>y_nfe_data,
      END OF y_nfe.
    DATA t_nfe TYPE STANDARD TABLE OF y_nfe WITH DEFAULT KEY.

    DATA:
      t_orig       TYPE STANDARD TABLE OF zcdsmm_c_edoc_it WITH DEFAULT KEY.

    MOVE-CORRESPONDING it_original_data TO t_orig.
*    SORT t_orig BY chave id.
    LOOP AT t_orig REFERENCE INTO DATA(r_orig).
      READ TABLE t_nfe
        INTO DATA(s_nfe)
        WITH KEY chave = r_orig->chave.
      IF ( NOT sy-subrc IS INITIAL ).
        s_nfe-chave = r_orig->chave.
        s_nfe-o_ref = NEW zcl_mm_nfe( r_orig->chave ).
        s_nfe-s_nfe_data = s_nfe-o_ref->get_nfe_data( iv_full = abap_true ).
        "
        APPEND s_nfe TO t_nfe.
      ENDIF.

      DATA(s_det) = s_nfe-o_ref->item_fetch( r_orig->id  ).

      r_orig->xprod = s_det-prod-xprod.
      r_orig->poprod = get_poprod( s_det ).
      r_orig->ucom = s_det-prod-ucom.
      r_orig->qcom = s_det-prod-qcom.
      r_orig->ncm = s_det-prod-ncm.
      r_orig->pomeins = s_det-po-ekpo-meins.
*      r_orig->pomenge = s_det-po-ekpo-menge.
      r_orig->pomenge = s_det-vlrs-menge.
      r_orig->potxz01 = s_det-po-ekpo-txz01.
      r_orig->qtrib = s_det-prod-qtrib.
      r_orig->utrib = s_det-prod-ucom.
      r_orig->poj1bnbm = s_det-po-ekpo-j_1bnbm.
      r_orig->poj1bmatorg = s_det-po-ekpo-j_1bmatorg.
      r_orig->cfop = s_det-prod-cfop.
*     r_orig->poj1bmatuse = s_det-po-ekpo-j_1bmatuse.
      r_orig->pomwskz = s_det-po-ekpo-mwskz.
      r_orig->vuntrib = s_det-prod-vuntrib.
      r_orig->powaers = s_det-po-ekko-waers.

      IF s_det-po-ekpo-j_1bmatuse IS NOT INITIAL.
        SELECT SINGLE ddtext
        INTO r_orig->poj1bmatuse
        FROM dd07t
        WHERE domname = 'J_1BMATUSE' AND
              ddlanguage = sy-langu  AND
              domvalue_l = s_det-po-ekpo-j_1bmatuse.
        CONCATENATE s_det-po-ekpo-j_1bmatuse '-'
                    r_orig->poj1bmatuse
               INTO r_orig->poj1bmatuse SEPARATED BY space.
      ENDIF.

      r_orig->ponetpr = s_det-vlrs-netpr-amnt.
      r_orig->ponetwr = s_det-vlrs-netwr-amnt.

*ICMS
      r_orig->icmscst = s_det-imposto-icms-cst.

      TRY.
          r_orig->poicmscst =
              s_det-po-t_komv[
                  kappl = 'TX'
                  kschl = 'BLIC'
              ]-knuma_bo.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      r_orig->icmsorig = s_det-imposto-icms-orig.
      r_orig->icmsvbc = s_det-imposto-icms-vbc.
      r_orig->picms = s_det-imposto-icms-picms.
      r_orig->vicms = s_det-imposto-icms-vicms.
      r_orig->vicmsdeson = s_det-imposto-icms-vicmsdeson.
*

      r_orig->poaliqicms = s_det-vlrs-icms-aliq.

      r_orig->povlicms = abs( s_det-vlrs-icms-amnt ).

*IPI
      r_orig->ipivbc = s_det-imposto-ipi-vbc.
      r_orig->pipi = s_det-imposto-ipi-pipi.
      r_orig->vipi = s_det-imposto-ipi-vipi.

      r_orig->poaliqipi = s_det-vlrs-ipi-aliq.

      r_orig->povlipi = s_det-vlrs-ipi-amnt.

*PIS
      r_orig->piscst = s_det-imposto-pis-cst.

      TRY.
          r_orig->popiscst =
              s_det-po-t_komv[
                  kappl = 'TX'
                  kschl = 'BLPI'
              ]-knuma_bo.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

*Cofins
      r_orig->cofinscst = s_det-imposto-cofins-cst.

      TRY.
          r_orig->pocofinscst =
              s_det-po-t_komv[
                  kappl = 'TX'
                  kschl = 'BLCO'
              ]-knuma_bo.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

***
      r_orig->vprod = s_det-prod-vprod.
      r_orig->vdesc = s_det-prod-vdesc.

      r_orig->povldesc = abs( s_det-vlrs-descsap-amnt ).

      r_orig->poinco1 = s_det-po-ekko-inco1.
      r_orig->poelikz = s_det-po-ekpo-elikz.
      r_orig->pomatkl = s_det-po-ekpo-matkl.
      SELECT SINGLE
            wgbez
          FROM t023t
          WHERE spras = @sy-langu
            AND matkl = @r_orig->pomatkl
          INTO @r_orig->powgbez.

      r_orig->poeindt =
        conv_date_out( CONV #( s_det-vlrs-eindt ) ).

      r_orig->powepos = s_det-po-ekpo-wepos.
      r_orig->poweunb = s_det-po-ekpo-weunb.
      r_orig->poablad = s_det-po-ekkn-ablad.
      r_orig->powempf = s_det-po-ekkn-wempf.
      r_orig->posakto = s_det-po-ekkn-sakto.
      r_orig->pokostl = s_det-po-ekkn-kostl.

*      r_orig->pobstae = s_det-po-ekpo-bstae.
      SELECT SINGLE
            bsbez
          FROM t163m
          WHERE spras = @sy-langu
            AND bstae = @s_det-po-ekpo-bstae
          INTO @r_orig->pobstae.

      r_orig->poprocstat = s_det-po-ekko-procstat.
      r_orig->poafnam = s_det-po-ekpo-afnam.

*      r_orig->poknttp = s_det-po-ekpo-knttp.
      IF s_det-po-ekpo-knttp IS NOT INITIAL.
        SELECT SINGLE knttx
        INTO r_orig->poknttp
        FROM t163i
        WHERE spras = sy-langu AND
              knttp = s_det-po-ekpo-knttp.

        CONCATENATE s_det-po-ekpo-knttp '-'
                    r_orig->poknttp
               INTO r_orig->poknttp SEPARATED BY space.
      ENDIF.
*      r_orig->poj1bindust = s_det-po-ekpo-j_1bindust.

      IF s_det-po-ekpo-j_1bindust IS NOT INITIAL.
        SELECT SINGLE ddtext
        INTO r_orig->poj1bindust
        FROM dd07t
        WHERE domname = 'J_1BINDUS3' AND
              ddlanguage = sy-langu  AND
              domvalue_l = s_det-po-ekpo-j_1bindust.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = s_det-po-ekpo-j_1bindust
          IMPORTING
            output = s_det-po-ekpo-j_1bindust.

        CONCATENATE s_det-po-ekpo-j_1bindust '-'
                    r_orig->poj1bindust
               INTO r_orig->poj1bindust SEPARATED BY space.
      ENDIF.

      r_orig->pobcicms = s_det-vlrs-icms-bc.

      r_orig->prunit =
        s_det-prod-vuncom.
*        (
*            r_orig->vprod
*            /
*            COND #(
*                WHEN r_orig->qcom <> 0
*                THEN r_orig->qcom
*                ELSE 1
*            )
*        ).

    ENDLOOP.

    MOVE-CORRESPONDING t_orig TO ct_calculated_data.
*
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    CASE iv_entity.
      WHEN 'ZCDSMM_C_EDOC_IT'.
        APPEND:
          'CHAVE' TO et_requested_orig_elements,
          'ID' TO et_requested_orig_elements.
    ENDCASE.
  ENDMETHOD.


  METHOD get_poprod.
    SELECT SINGLE
        maktx
      INTO @rv_poprod
      FROM makt
      WHERE matnr = @is_det-po-ekpo-matnr
        AND spras = @sy-langu.
    IF ( rv_poprod IS INITIAL ).
      SELECT SINGLE
          maktx
        INTO @rv_poprod
        FROM makt
        WHERE matnr = @is_det-po-ekpo-matnr
          AND spras = 'PT'.
    ENDIF.
  ENDMETHOD.


  METHOD conv_date_out.
    CHECK ( NOT iv_date_in IS INITIAL ).

    rv_date_out =
              |{ iv_date_in+6(2) }|
          &&  |/|
          &&  |{ iv_date_in+4(2) }|
          &&  |/|
          &&  |{ iv_date_in(4) }|.
  ENDMETHOD.
ENDCLASS.
