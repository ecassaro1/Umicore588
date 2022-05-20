***
* Branch level information is instantiated here.
**
* Jan/2022
* Eric Cassaro (Numen)
***

CLASS zcl_mm_nfe_branch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF y_branch,
        company_code TYPE j_1bbranch-branch,
        branch       TYPE j_1bbranch-bukrs,
        address      TYPE sadr,
        branch_data  TYPE j_1bbranch,
        cgc_number   TYPE j_1bwfield-cgc_number,
        address1     TYPE addr1_val,
*        s_t005       TYPE t005,
*        t_t007a      TYPE STANDARD TABLE OF t007a WITH DEFAULT KEY,
*        t_j_1batl1   TYPE STANDARD TABLE OF j_1batl1 WITH DEFAULT KEY,
*        t_j_1batl5   TYPE STANDARD TABLE OF j_1batl5 WITH DEFAULT KEY,
*        t_j_1batl4a  TYPE STANDARD TABLE OF j_1batl4a WITH DEFAULT KEY,
      END OF y_branch.

    DATA gs_branch TYPE y_branch.

    METHODS:
      constructor
        IMPORTING
          iv_company_code TYPE j_1bbranch-branch DEFAULT 'BR05'
          iv_branch       TYPE j_1bbranch-bukrs  DEFAULT '0001',

      get_data
        RETURNING
          VALUE(rs_data) TYPE y_branch.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_mm_nfe_branch IMPLEMENTATION.
  METHOD constructor.
*
    gs_branch-company_code = iv_company_code.
    gs_branch-branch = iv_branch.

    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
      EXPORTING
        branch            = gs_branch-branch
        bukrs             = gs_branch-company_code
      IMPORTING
        address           = gs_branch-address
        branch_data       = gs_branch-branch_data
        cgc_number        = gs_branch-cgc_number
        address1          = gs_branch-address1
      EXCEPTIONS
        branch_not_found  = 1
        address_not_found = 2
        company_not_found = 3.

**fiscal data
*    SELECT SINGLE
*       *
*       INTO @gs_branch-s_t005
*       FROM t005
*       WHERE land1 = @gs_branch-address-land1.
*
*    SELECT
*      *
*      INTO TABLE @gs_branch-t_t007a
*      FROM t007a
*      WHERE kalsm = @gs_branch-s_t005-kalsm.
*
*    IF ( NOT gs_branch-t_t007a IS INITIAL ).
*      SELECT
*          *
*          INTO TABLE @gs_branch-t_j_1batl1
*          FROM j_1batl1
*          FOR ALL ENTRIES IN @gs_branch-t_t007a
*          WHERE taxlaw = @gs_branch-t_t007a-j_1btaxlw1.
*
*      SELECT
*          *
*          INTO TABLE @gs_branch-t_j_1batl5
*          FROM j_1batl5
*          FOR ALL ENTRIES IN @gs_branch-t_t007a
*          WHERE taxlaw = @gs_branch-t_t007a-j_1btaxlw5.
*
*      SELECT
*          *
*          INTO TABLE @gs_branch-t_j_1batl4a
*          FROM j_1batl4a
*          FOR ALL ENTRIES IN @gs_branch-t_t007a
*          WHERE taxlaw = @gs_branch-t_t007a-j_1btaxlw4.
*    ENDIF.
  ENDMETHOD.

  METHOD get_data.
    rs_data = gs_branch.
  ENDMETHOD.
ENDCLASS.
