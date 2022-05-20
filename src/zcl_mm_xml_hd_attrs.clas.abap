***
* Virtual elements for the XML_HD
**
* Jan/2022
* Eric Cassaro (Numen)
***

CLASS zcl_mm_xml_hd_attrs DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_xml_hd_attrs IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
*
    DATA:
      t_orig       TYPE STANDARD TABLE OF zcdsmm_c_xml WITH DEFAULT KEY.

    MOVE-CORRESPONDING it_original_data TO t_orig.

    LOOP AT t_orig REFERENCE INTO DATA(r_orig).
*Divergencies
      SELECT
          coddiv
          FROM zcdsmm_i_xml_hd_cod
          WHERE chave = @r_orig->chave
          INTO TABLE @DATA(t_div).

      "concatenate all the divergency codes
      LOOP AT t_div INTO DATA(s_div).
        r_orig->divergencias =
                |{ r_orig->divergencias }|
            &&  |{ COND char1(
                    WHEN ( r_orig->divergencias IS INITIAL )
                        THEN ''
                        ELSE ';') }|
            &&  |{ s_div-coddiv }|.
      ENDLOOP.

**RefXMLStr
*      DATA(o_nfe) = NEW zcl_mm_nfe( r_orig->chave ).
*      DATA(s_nfe_data) = o_nfe->get_nfe_data( iv_full = abap_true ).
*      DATA(s_ref_nfe_data) = o_nfe->get_ref_nfe_data( ).
*
*      r_orig->refxmlstr = s_ref_nfe_data-xml_str.
    ENDLOOP.

    MOVE-CORRESPONDING t_orig TO ct_calculated_data.
*
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    CASE iv_entity.
      WHEN 'ZCDSMM_C_XML'.
        APPEND 'CHAVE' TO et_requested_orig_elements.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
