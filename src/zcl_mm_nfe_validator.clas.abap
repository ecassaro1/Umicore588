***
* Commands the execution of all the validation rules. All static. Just switch the things.
* Main method is VALIDATE_ITEM.
***

CLASS zcl_mm_nfe_validator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF tag2rule,
        seq         TYPE i,
        tagxmlhdr   TYPE zcdsmm_i_xml_regra-tagxmlhdr,
        tagxmlitem  TYPE zcdsmm_i_xml_regra-tagxmlitem,
        rule_number TYPE i,
        description TYPE string,
        dependence  TYPE i,
      END OF tag2rule,
      BEGIN OF y_rule,
        s_xml_regra TYPE zcdsmm_i_xml_regra,
        seq         TYPE i,
        rule_number TYPE i,
        rule_class  TYPE string,
        result      TYPE zcdsmm_i_xml_regra-statusvalid,
      END OF y_rule,
      y_t_error TYPE STANDARD TABLE OF zcdsmm_i_log_erros WITH DEFAULT KEY.

    CLASS-DATA:
      gt_tag2rule  TYPE STANDARD TABLE OF tag2rule WITH DEFAULT KEY,
      gt_xml_regra TYPE STANDARD TABLE OF zcdsmm_i_xml_regra WITH DEFAULT KEY,
      gt_rule      TYPE STANDARD TABLE OF y_rule WITH DEFAULT KEY.

    CLASS-METHODS:
      class_constructor,

      build_tag2rule,

      build_rules_mapping,

      build_single_rule_mapping
        IMPORTING
          is_regra       TYPE zcdsmm_i_xml_regra
        RETURNING
          VALUE(rs_rule) TYPE y_rule,

      get_rule_from_tag
        IMPORTING
          is_xml_regra  TYPE zcdsmm_i_xml_regra
        RETURNING
          VALUE(rs_t2r) TYPE tag2rule,

      validate_item
        IMPORTING
          !io_nfe         TYPE REF TO zcl_mm_nfe
          !iv_id          TYPE zcdsmm_i_xml_hist_it-id
        RETURNING
          VALUE(rt_error) TYPE y_t_error,

      dependence
        IMPORTING
          is_rule      TYPE y_rule
        RETURNING
          VALUE(rv_ok) TYPE abap_bool,

      clear_rules_results.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_mm_nfe_validator IMPLEMENTATION.

  METHOD class_constructor.
    build_tag2rule( ).
    build_rules_mapping( ).
  ENDMETHOD.

  METHOD build_tag2rule.
*
* The user fills the ZCDSMM_I_XML_REGRA table, which has header and item tags as its key.
* We must relate this tags to actual rules. Here we construct this mapping.
*
    DEFINE t2r.
      APPEND
          VALUE #(
               seq = &1
               tagxmlhdr = &2       " header tag as specified in the XML_REGRA table
               tagxmlitem = &3      " item tag as specified in the XML_REGRA table
               rule_number = &4     " rule number matching the class implementation
               dependence = &5      " does it depends on other rule? If not, then zero
               description = &6     " short description of the rule (as in the EF), just for reference
          )
        TO gt_tag2rule.
    END-OF-DEFINITION.

    t2r:
*       seq taghdr      tagitm          number  dependence  description
         10 '<PROD>'    '<XPED>'        1       0           'Pedido de compras',
         20 '<PROD>'    '<NITEMPED>'    8       1           'Item do pedido',
         25 '<PROD>'    '<CPROD>'       29      8           'Pedido/Item já utilizado',
         30 '<EMIT>'    '<CNPJ>'        2       29          'CNPJ do fornecedor',
         40 '<EMIT>'    '<IE>'          3       29          'Inscrição Estadual fornecedor',
         50 '<DEST>'    '<CNPJ>'        4       0           'CNPJ destino (COIMPA)',
         60 '<DEST>'    '<IE>'          5       0           'Inscrição Estadual de Destino (COIMPA)',
         70 '<DEST>'    '<ISUF>'        6       0           'Inscrição Suframa (COIMPA)',
         80 '<ICMS>'    '<PICMS>'       7       29          'Alíquota do ICMS',
         90 '<PROD>'    '<XPROD>'       9       29          'Descrição do material (texto breve)',
        100 '<ICMS>'    '<CST>'         10      29          'CST ICMS divergente',
        110 '<PIS>'     '<CST>'         11      29          'CST PIS divergente',
        120 '<COFINS>'  '<CST>'         12      29          'CST COFINS divergente',
        130 '<ICMS>'    '<VBC>'         13      29          'Base de ICMS divergente',
        140 '<ICMS>'    '<VICMS>'       14      29          'Valor ICMS divergente',
        150 '<ICMS>'    '<VICMSDESON>'  15      29          'Valor do ICMS desonerado (se for o caso)',
        160 '<PROD>'    '<VDESC>'       16      29          'Valor do desconto',
        170 '<ICMSTOT>' '<VNF>'         17      29          'Valor total da Nota Fiscal',
        180 '<PROD>'    '<CFOP>'        18      29          'CFOP de vendas para ZFM',
        190 '<PROD>'    '<NCM>'         19      29          'NCM do produto',
        200 '<PROD>'    '<ORIG>'        20      29          'Origem do Material',
        210 '<PROD>'    '<PIPI>'        21      29          'Alíquota de IPI',
        220 '<PROD>'    '<VIPI>'        22      29          'Valor do IPI',
*                                       23                  "dummy
        240 '<PROD>'    '<VUNTRIB>'     24      29          'Preço Bruto Unitário divergente',
        250 '<PROD>'    '<UTRIB>'       25      29          'Unidade de Medida',
        260 '<PROD>'    '<QTRIB>'       26      29          'Quantidade',
        270 '<TRANSP>'  '<MODFRETE>'    27      29          'Modo do Frete',
        280 '<COBR>'    '<DVENC>'       28      29          'Data de Vencimento da Fatura'.

  ENDMETHOD.

  METHOD build_rules_mapping.
*
* Here we build the GT_RULE table containing the XML_REGRA table data as well
* as the rule number and its corresponding implementation class (the class
* names match the rule number).
*
    SELECT
        *
      FROM zcdsmm_i_xml_regra
      INTO CORRESPONDING FIELDS OF TABLE @gt_xml_regra.

    LOOP AT gt_xml_regra INTO DATA(s_regra).
      DATA(s_rule) = build_single_rule_mapping( s_regra ).
      CHECK ( NOT s_rule IS INITIAL ).

      APPEND
           VALUE #(
                s_xml_regra = s_regra
                seq         = s_rule-seq
                rule_number = s_rule-rule_number
                rule_class  = s_rule-rule_class
                result      = s_rule-result
           )
         TO gt_rule.
    ENDLOOP.

    SORT gt_rule BY seq.
  ENDMETHOD.

  METHOD build_single_rule_mapping.
*
* Here we build a rule mapping entry (to be called from build_rules_mapping)
*
    DATA:
      v_class_name     TYPE string,
      v_rule_number(2) TYPE n.

    DATA(s_t2r) =
        get_rule_from_tag( is_xml_regra = is_regra ).

    CHECK ( NOT s_t2r IS INITIAL ).

    v_rule_number = s_t2r-rule_number.

    rs_rule =
        VALUE #(
            s_xml_regra = is_regra
            rule_number = s_t2r-rule_number
            seq         = s_t2r-seq
            rule_class  = |ZCL_MM_NFE_RULE_{ v_rule_number }|
            result      = ''
        ).
  ENDMETHOD.

  METHOD get_rule_from_tag.
*
* From the tabs fetches an entry from the GT_TAG2RULE table so the
* build_rule_mapping can use the info to map the corresponding
* rule implementation class.
*
    TRY.
        rs_t2r =
            gt_tag2rule[
                tagxmlhdr = is_xml_regra-tagxmlhdr
                tagxmlitem = is_xml_regra-tagxmlitem
            ].
      CATCH cx_sy_itab_line_not_found.
        "not implemented rule, but some smart one put it in the table
    ENDTRY.
  ENDMETHOD.

  METHOD validate_item.
***
* MAIN METHOD. Called from the NFe class when validating an item.
***
* Run every rule (the rules were built at the class-constructor)
***
    DATA lv_leave TYPE boolean.
    clear_rules_results( ).
*-> Start - Some CFOP's should not Be validated
    DATA o_rule TYPE REF TO zif_mm_nfe_rule.
    DATA(lo_const) = NEW zcl_gl_constante( 'Z_CFOP_CONSERT' ).
    DATA(lt_cfop1) = lo_const->get_tvarv_any_table( 'Z_CFOP_CONSERTO' ).
    LOOP AT io_nfe->gs_nfe_data-infnfe-det INTO DATA(det).
      IF det-prod-cfop IN lt_cfop1[].
        lv_leave = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.

    lt_cfop1 = lo_const->get_tvarv_any_table( 'Z_CFOP_CONSERT_MOV' ).
    LOOP AT io_nfe->gs_nfe_data-infnfe-det INTO det.
      IF det-prod-cfop IN lt_cfop1[].
        lv_leave = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.
    IF lv_leave = abap_true.
      RETURN.
    ENDIF.
*-> End - Some CFOP's should not Be validated
    LOOP AT gt_rule REFERENCE INTO DATA(r_rule).
      CHECK ( dependence( r_rule->* ) = abap_true ).

      CREATE OBJECT o_rule TYPE (r_rule->rule_class)
          EXPORTING
              io_nfe = io_nfe
              iv_id = iv_id
              is_regra = r_rule->s_xml_regra.

      DATA(s_error) = o_rule->validate( ).

      IF ( s_error IS INITIAL ). "OK
        r_rule->result = zcl_mm_nfe=>c_status_valid-ok.
      ELSE.
        r_rule->result = s_error-statusvalid.

        APPEND
            s_error
            TO rt_error.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD dependence.
*
* It must be the case that the execution of a rule depends on the success of
* a previous one. Here we check for this dependence.
*
    rv_ok = abap_true. "let´s start it as ok and check for issues

    DATA(s_t2r) =
        get_rule_from_tag( is_xml_regra = is_rule-s_xml_regra ).

    CHECK ( s_t2r-dependence <> 0 ). "if there is no dependence, let it go

*check what was the result of the dependence
    DATA(v_result) =
        gt_rule[
            rule_number = s_t2r-dependence
        ]-result.

    CHECK ( v_result <> zcl_mm_nfe=>c_status_valid-ok ). "was it nok?

*if the dependence result was not OK then we must not proceed with the current validation
    rv_ok = abap_false.
  ENDMETHOD.

  METHOD clear_rules_results.
    LOOP AT gt_rule REFERENCE INTO DATA(r_rule).
      r_rule->result = ''.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
