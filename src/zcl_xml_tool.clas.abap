***
* This tool can fetch values from the XML tags inside a XML string.
* GET_VALUE returns the value inside the first tag found with the given name, such as 'XPed'.
* GET_DEEP_VALUE receives a value such as 'infNFe/emit/enderEmit/xMun' and goes searching inside
* each token.
**
* Jan/2022
* Eric Cassaro (Numen)
***

CLASS zcl_xml_tool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA:
      gv_xml TYPE string.

    METHODS:
      constructor
        IMPORTING
          iv_str_xml TYPE string,

      get_deep_value
        IMPORTING
          iv_path         TYPE string
        RETURNING
          VALUE(rv_value) TYPE string,

      get_value
        IMPORTING
          iv_base         TYPE string
          iv_tag          TYPE string
        RETURNING
          VALUE(rv_value) TYPE string.

    CLASS-METHODS:
      close_tag
        IMPORTING
          iv_open         TYPE string
        RETURNING
          VALUE(rv_close) TYPE string.
  PROTECTED SECTION.


  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_xml_tool IMPLEMENTATION.
  METHOD constructor.
    gv_xml = iv_str_xml.
  ENDMETHOD.

  METHOD get_value.
    CHECK ( NOT gv_xml IS INITIAL ).
*
    DATA:
      base LIKE iv_base,
      tag  LIKE iv_tag,
      ini  TYPE i,
      fin  TYPE i,
      len  TYPE i.

    base = iv_base.

    tag = iv_tag.

*find the begining of the openning tag
    FIND |<{ tag }| IN base MATCH OFFSET ini.
    CHECK ( sy-subrc IS INITIAL ).

*rebase
    len = strlen( base ) - ini.
    base = base+ini(len).

*find the ending of the openning tag
    FIND '>' IN base MATCH OFFSET fin.
    CHECK ( sy-subrc IS INITIAL ).
    fin += 1.

*rebase
    len = strlen( base ) - fin.
    base = base+fin(len).

*find the closing tag
*    DATA(close) = close_tag( |<{ tag }>| ).
    DATA(close) = close_tag( |<{ tag }| ).
    FIND close IN base MATCH OFFSET fin.
    CHECK ( sy-subrc IS INITIAL ).

*return the found value
    rv_value = base(fin).
*
  ENDMETHOD.

  METHOD get_deep_value.
    CHECK ( NOT gv_xml IS INITIAL ).
*
    DATA(base) = gv_xml.

    DATA t_token TYPE STANDARD TABLE OF string.

    SPLIT iv_path AT '/' INTO TABLE t_token.

    LOOP AT t_token INTO DATA(tag).
      base =
          get_value(
              iv_base = base
              iv_tag = tag
          ).
    ENDLOOP.
*
    rv_value = base.
*
  ENDMETHOD.

  METHOD close_tag.
*build a closing tag for a given one
*
    DATA:
      v_base  TYPE string,
      v_void1 TYPE string,
      len     TYPE i.


    FIND '>' IN iv_open.
    IF ( sy-subrc IS INITIAL ).
      DATA(v_has_closing) = abap_true.
    ENDIF.

    SPLIT iv_open AT ' ' INTO v_base v_void1.

    len = strlen( v_base ).
    IF (
*        ( v_void1 IS INITIAL )
*        AND
        ( v_has_closing = abap_true )
       ). "the closing '>' has been left at the end of v_base
      len = ( len - 1 ).
    ELSE.
      v_base = |{ v_base }>|. "the closing '>' must be added at the end of v_base
    ENDIF.

    rv_close =
        |</{ v_base+1(len) }|.
*
  ENDMETHOD.
ENDCLASS.
