**
* NFe BO in the context of the XML validation. This BO represents a NFe entity with
* all it´s relevant data and methods.
**
* Jan/2022
* Eric Cassaro (Numen)
**

CLASS zcl_mm_nfe DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF y_po,
        ekko            TYPE ekko,
        ekpo            TYPE ekpo,
        eket            TYPE eket,
        t_eket          TYPE STANDARD TABLE OF eket WITH DEFAULT KEY,
        ekkn            TYPE ekkn,
        t_prcd_elements TYPE STANDARD TABLE OF prcd_elements WITH DEFAULT KEY,
        t_komv          TYPE komv_t,
        lfa1            TYPE lfa1,
      END OF y_po,

      BEGIN OF y_pr,
        t_item_condition TYPE STANDARD TABLE OF bapimeoutcondition WITH DEFAULT KEY,
      END OF y_pr,

      BEGIN OF y_vlr,
        amnt TYPE kbetr,
        aliq TYPE kbetr,
        bc   TYPE kwert,
*        value TYPE kwert,
      END OF y_vlr,

      BEGIN OF y_vlrs,
        netpr     TYPE y_vlr,
        icms      TYPE y_vlr,
        icmsdeson TYPE y_vlr,
        ipi       TYPE y_vlr,
        descsap   TYPE y_vlr,
        eindt     TYPE eket-eindt,
        netwr     TYPE y_vlr,
        menge     TYPE ekpo-menge,
      END OF y_vlrs,

      BEGIN OF y_det,
        BEGIN OF prod,
          nitem(6)    TYPE n,
          xprod(120)  TYPE c,
          ucom(6)     TYPE c,
          qcom(16)    TYPE c,
          ncm(8)      TYPE c,
          xped(15)    TYPE c,
          nitemped(6) TYPE n,
          qtrib(16)   TYPE c,
          cfop(4)     TYPE c,
          utrib(3)    TYPE c,
          vuntrib(22) TYPE c,
          vuncom(22)  TYPE c,
          vprod(16)   TYPE c,
          vdesc(16)   TYPE c,
          vfrete(16)  TYPE c,
          vseg(16)    TYPE c,
          voutro(16)  TYPE c,
          cprod(60)   TYPE c,
          "nfci(16) type c, não consta no manual...
          ceantrib    TYPE string,
          cean        TYPE string,
        END OF prod,

        BEGIN OF imposto,
          BEGIN OF icms,
            picms(8)       TYPE c,
            orig(1)        TYPE c,
            cst(2)         TYPE c,
            vbc(16)        TYPE c,
            vicms(16)      TYPE c,
            vicmsdeson(16) TYPE c,
            vicmsst(16)    TYPE c,
            motdesicms(16) TYPE c,
          END OF icms,
          BEGIN OF ipi,
            pipi(8)  TYPE c,
            vbc(16)  TYPE c,
            vipi(16) TYPE c,
          END OF ipi,
          BEGIN OF pis,
            cst(2) TYPE c,
          END OF pis,
          BEGIN OF cofins,
            cst(2) TYPE c,
          END OF cofins,
        END OF imposto,

        po      TYPE y_po,

        pr      TYPE y_pr,

        hist_it TYPE zcdsmm_i_xml_hist_it,

        v_nf    TYPE ekpo-brtwr,

        vlrs    TYPE y_vlrs,
      END OF y_det,

      BEGIN OF y_nfe_data,
        file_raw TYPE edocumentfile-file_raw,
        xml_str  TYPE string,
        BEGIN OF infnfe,
          BEGIN OF ide,
            cuf      TYPE string,
            cnf      TYPE string,
            natop    TYPE string,
            tpnf     TYPE string,
            finnfe   TYPE string,
            nnf      TYPE string,
            dhemi    TYPE string,
            tpemis   TYPE string,
            indfinal TYPE string,
            indpres  TYPE string,
            iddest   TYPE string,
            BEGIN OF nfref,
              refnfe TYPE string,
              nnf    TYPE string,
            END OF nfref,
          END OF ide,
          BEGIN OF emit,
            xnome TYPE string,
            cnpj  TYPE string,
            ie    TYPE string,
            crt   TYPE string,
            BEGIN OF enderemit,
              xbairro TYPE string,
              xlgr    TYPE string,
              nro     TYPE string,
              xcpl    TYPE string,
              cep     TYPE string,
              cmun    TYPE string,
              xmun    TYPE string,
              uf      TYPE string,
              cpais   TYPE string,
              xpais   TYPE string,
              fone    TYPE string,
            END OF enderemit,
          END OF emit,
          BEGIN OF dest,
            xnome TYPE string,
            cnpj  TYPE string,
            isuf  TYPE string,
            ie    TYPE string,
            crt   TYPE string,
            email TYPE string,
          END OF dest,
          det TYPE STANDARD TABLE OF y_det WITH KEY prod-nitem,
          BEGIN OF total,
            BEGIN OF icmstot,
              vnf TYPE prcd_elements-kbetr,
            END OF icmstot,
          END OF total,
          BEGIN OF transp,
            modfrete TYPE numc1,
            BEGIN OF transporta,
              xnome TYPE string,
              cnpj  TYPE string,
            END OF transporta,
            BEGIN OF veictransp,
              placa TYPE string,
            END OF veictransp,
            BEGIN OF vol,
              qvol  TYPE string,
              esp   TYPE string,
              pesob TYPE string,
              pesol TYPE string,
            END OF vol,
          END OF transp,
          BEGIN OF cobr,
            BEGIN OF dup,
              dvenc TYPE string,
            END OF dup,
          END OF cobr,
          BEGIN OF pag,
            BEGIN OF detpag,
              indpag TYPE string,
            END OF detpag,
          END OF pag,
        END OF infnfe,

        BEGIN OF protnfe,
          BEGIN OF infprot,
            nprot TYPE string,
            cstat TYPE string,
          END OF infprot,
        END OF protnfe,

        v_nf     TYPE ekpo-brtwr,

        BEGIN OF ref,
          nfenum  TYPE j_1bnfdoc-nfenum,
          pstdat  TYPE j_1bnfdoc-pstdat,
          nftot   TYPE j_1bnfdoc-nftot,
          docnum  TYPE j_1bnfdoc-docnum,
          xml_str TYPE string,
        END OF ref,
      END OF y_nfe_data,

      y_t_log TYPE STANDARD TABLE OF zcdsmm_i_log_erros WITH DEFAULT KEY.

    CONSTANTS:
      BEGIN OF c_status_valid,
        ok        TYPE zcdsmm_i_xml_hist_it-statusvalid VALUE 'S',
        incorrect TYPE zcdsmm_i_xml_hist_it-statusvalid VALUE 'E',
        warning   TYPE zcdsmm_i_xml_hist_it-statusvalid VALUE 'W',
        canceled  TYPE zcdsmm_i_xml_hist_it-statusvalid VALUE 'C',
      END OF c_status_valid,

      BEGIN OF c_status,
        undefined TYPE zcdsmm_i_xml_hist_hd-status VALUE '0',
        released  TYPE zcdsmm_i_xml_hist_hd-status VALUE '1',
        archived  TYPE zcdsmm_i_xml_hist_hd-status VALUE '2',
        undone    TYPE zcdsmm_i_xml_hist_hd-status VALUE '3',
        rejected  TYPE zcdsmm_i_xml_hist_hd-status VALUE '9',
      END OF c_status.


    DATA:
      gv_accesskey     TYPE edobrincoming-accesskey,
      gs_edobrincoming TYPE edobrincoming,
      gs_edocument     TYPE edocument,
      gs_edocumentfile TYPE edocumentfile,
      gv_str_xml       TYPE string,
      go_xml_tool      TYPE REF TO zcl_xml_tool,
      gs_nfe_data      TYPE y_nfe_data,
      go_branch        TYPE REF TO zcl_mm_nfe_branch,
      gv_is_full       TYPE abap_bool,
      gv_doc_type      TYPE char2, "PO or PR
      gv_is_ref        TYPE abap_bool.

    CLASS-METHODS:
      short_id
        IMPORTING
          iv_id        TYPE zcdsmm_i_xml_hist_it-id
        RETURNING
          VALUE(rv_id) TYPE zcdsmm_i_xml_hist_it-id,

      mid_id
        IMPORTING
          iv_id        TYPE zcdsmm_i_xml_hist_it-id
        RETURNING
          VALUE(rv_id) TYPE y_det-prod-nitem.

    METHODS:
      constructor
        IMPORTING
          iv_accesskey TYPE edobrincoming-accesskey
          iv_is_ref    TYPE abap_bool OPTIONAL,

      get_value
        IMPORTING
          iv_tag          TYPE string
        RETURNING
          VALUE(rv_value) TYPE string,

      get_value_skip
        IMPORTING
          iv_path         TYPE string
          iv_skip_to      TYPE string
        RETURNING
          VALUE(rv_value) TYPE string,

      get_nfe_data
        IMPORTING
          iv_full            TYPE abap_bool DEFAULT ''
          iv_with_ref        TYPE abap_bool DEFAULT ''
        RETURNING
          VALUE(rs_nfe_data) TYPE y_nfe_data,

      item_fetch
        IMPORTING
          iv_id         TYPE zcdsmm_i_xml_hist_it-id
        RETURNING
          VALUE(rs_det) TYPE y_det,

      validate_item
        IMPORTING
          iv_id         TYPE zcdsmm_i_xml_hist_it-id
        RETURNING
          VALUE(rt_log) TYPE y_t_log.
  PROTECTED SECTION.

    METHODS:
      build_xml_data,

      std_data,

      get_taxval_komv
        IMPORTING
          is_det         TYPE y_det
          iv_qt_parc     TYPE ekpo-ktmng OPTIONAL
        RETURNING
          VALUE(rt_komv) TYPE komv_t,

      get_prcd_element
        IMPORTING
          is_det                 TYPE y_det
          iv_kschl               TYPE prcd_elements-kschl
        RETURNING
          VALUE(rs_prcd_element) TYPE prcd_elements,

      get_item_condition
        IMPORTING
          is_det                   TYPE y_det
          iv_cond_type             TYPE bapimeoutcondition-cond_type
        RETURNING
          VALUE(rs_item_condition) TYPE LINE OF y_det-pr-t_item_condition,

      vlrs_calc_po "purchase order
        IMPORTING
          is_det        TYPE y_det
        RETURNING
          VALUE(rs_det) TYPE y_det,

      vlrs_calc_pr "programa de remessa
        IMPORTING
          is_det        TYPE y_det
        RETURNING
          VALUE(rs_det) TYPE y_det,

      build_ref_data
        IMPORTING
          iv_tpnf       LIKE gs_nfe_data-infnfe-ide-tpnf
        RETURNING
          VALUE(rs_ref) LIKE gs_nfe_data-ref.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_nfe IMPLEMENTATION.


  METHOD constructor.
    gv_accesskey = iv_accesskey.
    gv_is_ref = iv_is_ref.

    SELECT SINGLE
        *
      INTO @gs_edobrincoming
      FROM edobrincoming
      WHERE accesskey = @gv_accesskey.

    SELECT SINGLE
      *
      INTO @gs_edocument
      FROM edocument
      WHERE edoc_guid = @gs_edobrincoming-edoc_guid.

    SELECT SINGLE
      *
      INTO @gs_edocumentfile
      FROM edocumentfile
      WHERE file_guid = @gs_edocument-file_guid.

    gv_str_xml = cl_soap_xml_helper=>xstring_to_string( gs_edocumentfile-file_raw ).

    go_xml_tool = NEW zcl_xml_tool( gv_str_xml ).

    go_branch = NEW zcl_mm_nfe_branch( ).

  ENDMETHOD.


  METHOD get_value.
    rv_value = go_xml_tool->get_deep_value( iv_tag ).
  ENDMETHOD.


  METHOD get_value_skip.
    DATA(s_base) = get_value( iv_path ).

    rv_value =
        go_xml_tool->get_value(
            iv_base = s_base
            iv_tag  = |{ iv_skip_to }>|
        ).
  ENDMETHOD.


  METHOD build_xml_data.
*
    TYPES:
      BEGIN OF y_map,
        itab_path TYPE string,
        xml_path  TYPE string,
        skip_to   TYPE string,
      END OF y_map,
      y_t_map TYPE STANDARD TABLE OF y_map.

    DATA t_map TYPE y_t_map.
    DATA: lv_xped TYPE string.

    DEFINE map.
      APPEND
          VALUE #(
              itab_path = &1
              xml_path  = &2
              skip_to   = &3
          ) TO t_map.
    END-OF-DEFINITION.

    map:
      'infnfe-ide-cuf' 'infNFe/ide/cUF' '',
      'infnfe-ide-cnf' 'infNFe/ide/cNF' '',
      'infnfe-ide-natop' 'infNFe/ide/natOp' '',
      'infnfe-ide-tpnf' 'infNFe/ide/tpNF' '',
      'infnfe-ide-finnfe' 'infNFe/ide/finNFe' '',
      'infnfe-ide-dhemi' 'infNFe/ide/dhEmi' '',
      'infnfe-ide-nnf' 'infNFe/ide/nNF' '',
      'infnfe-ide-nfref-refnfe' 'infNFe/ide/NFref/refNFe' '',
      'infnfe-ide-nfref-nnf' 'infNFe/ide/NFref/nNF' '',
      'infnfe-emit-xnome' 'infNFe/emit/xNome' '',
      'infnfe-emit-cnpj' 'infNFe/emit/CNPJ' '',
      'infnfe-emit-ie' 'infNFe/emit/IE' '',
      'infnfe-dest-xnome' 'infNFe/dest/xNome' '',
      'infnfe-dest-cnpj' 'infNFe/dest/CNPJ' '',
      'infnfe-dest-ie' 'infNFe/dest/IE' '',
      'infnfe-dest-isuf' 'infNFe/dest/ISUF' '',
      'infnfe-dest-crt' 'infNFe/dest/CRT' '',
      'infnfe-dest-email' 'infNFe/dest/email' '',
      'infnfe-emit-enderemit-xbairro' 'infNFe/emit/enderEmit/xBairro' '',
      'infnfe-emit-enderemit-xlgr' 'infNFe/emit/enderEmit/xLgr' '',
      'infnfe-emit-enderemit-nro' 'infNFe/emit/enderEmit/nro' '',
      'infnfe-emit-enderemit-xcpl' 'infNFe/emit/enderEmit/xCpl' '',
      'infnfe-emit-enderemit-cep' 'infNFe/emit/enderEmit/CEP' '',
      'infnfe-emit-enderemit-cmun' 'infNFe/emit/enderEmit/cMun' '',
      'infnfe-emit-enderemit-xmun' 'infNFe/emit/enderEmit/xMun' '',
      'infnfe-emit-enderemit-uf' 'infNFe/emit/enderEmit/UF' '',
      'infnfe-emit-enderemit-cpais' 'infNFe/emit/enderEmit/cPais' '',
      'infnfe-emit-enderemit-xpais' 'infNFe/emit/enderEmit/xPais' '',
      'infnfe-emit-enderemit-fone' 'infNFe/emit/enderEmit/fone' '',
      'infnfe-emit-crt' 'infNFe/emit/CRT' '',
      'infnfe-transp-modfrete' 'infNFe/transp/modFrete' '',
      'infnfe-transp-transporta-xnome' 'infNFe/transp/transporta/xNome' '',
      'infnfe-transp-transporta-cnpj' 'infNFe/transp/transporta/CNPJ' '',
      'infnfe-cobr-dup-dvenc' 'infNFe/cobr/dup/dVenc' '',
      'infnfe-total-icmstot-vnf' 'infNFe/total/ICMSTot/vNF' '',

      'infnfe-transp-veictransp-placa' 'infNFe/transp/veicTransp/placa' '',
      'infnfe-transp-vol-qvol' 'infNFe/transp/vol/qVol' '',
      'infnfe-transp-vol-esp' 'infNFe/transp/vol/esp' '',
      'infnfe-transp-vol-pesob' 'infNFe/transp/vol/pesoB' '',
      'infnfe-transp-vol-pesol' 'infNFe/transp/vol/pesoL' '',
      'infnfe-ide-tpemis' 'infNFe/ide/tpemis' '',
      'infnfe-ide-indfinal' 'infNFe/ide/indFinal' '',
      'infnfe-ide-indpres' 'infNFe/ide/indPres' '',
      'infnfe-ide-iddest' 'infNFe/ide/idDest' '',
      'infnfe-pag-detpag-indpag' 'infNFe/pag/detPag/indPag' '',

      'protnfe-infprot-nprot' 'protNFe/infProt/nProt' '',
      'protnfe-infprot-cstat' 'protNFe/infProt/cStat' ''.


    LOOP AT t_map INTO DATA(s_map).
      ASSIGN COMPONENT s_map-itab_path OF STRUCTURE gs_nfe_data TO FIELD-SYMBOL(<nfe_comp>).
      CHECK ( sy-subrc IS INITIAL ).

      <nfe_comp> = get_value( s_map-xml_path ).
*remove invalid charact
      IF s_map-itab_path EQ 'infnfe-emit-xnome' OR
         s_map-itab_path EQ 'infnfe-dest-xnome'.
        lv_xped = <nfe_comp>.
        REPLACE ALL OCCURRENCES OF '&amp;' IN lv_xped WITH '&'.
        <nfe_comp> = lv_xped.
      ENDIF.
    ENDLOOP.

    gs_nfe_data-file_raw = gs_edocumentfile-file_raw.
    gs_nfe_data-xml_str  = gv_str_xml.

*
***
* Items
*
    DATA v_nitem TYPE i.
    DO.
      v_nitem += 1.

      DATA(v_path_tst) =
          |infNFe/det nItem="{ v_nitem }"/prod/cProd|.

      DATA(v_cprod_tst) = get_value( v_path_tst ).

      IF ( v_cprod_tst IS INITIAL ).
*when there is no more itens, leave the loop
        EXIT.
      ENDIF.

*fetch the item attrs
      DATA s_det TYPE LINE OF y_nfe_data-infnfe-det.

      s_det-prod-nitem = v_nitem.

      CLEAR t_map.

      map:
        'prod-xprod'                'prod/xProd'                        '',
        'prod-xped'                 'prod/xPed'                         '',
        'prod-nitemped'             'prod/nItemPed'                     '',
        'prod-ucom'                 'prod/uCom'                         '',
        'prod-qcom'                 'prod/qCom'                         '',
        'prod-ncm'                  'prod/NCM'                          '',
        'prod-qtrib'                'prod/qTrib'                        '',
        'prod-utrib'                'prod/uTrib'                        '',
        'prod-cfop'                 'prod/CFOP'                         '',
        'prod-vuntrib'              'prod/vUnTrib'                      '',
        'prod-vuncom'               'prod/vUnCom'                       '',
        'prod-vprod'                'prod/vProd'                        '',
        'prod-vdesc'                'prod/vDesc'                        '',

        'imposto-icms-picms'        'imposto/ICMS'                      'pICMS',
        'imposto-icms-vbc'          'imposto/ICMS'                      'vBC',
        'imposto-icms-vicms'        'imposto/ICMS'                      'vICMS',
        'imposto-icms-orig'         'imposto/ICMS'                      'orig',
        'imposto-icms-cst'          'imposto/ICMS'                      'CST',
        'imposto-icms-vicmsdeson'   'imposto/ICMS'                      'vICMSDeson',
        'imposto-icms-vicmsst'      'imposto/ICMS'                      'vICMSST',
        'imposto-icms-motdesicms'   'imposto/ICMS'                      'motDesICMS',

        'imposto-ipi-pipi'          'imposto/IPI'                       'pIPI',
        'imposto-ipi-vbc'           'imposto/IPI'                       'vBC',
        'imposto-ipi-vipi'          'imposto/IPI'                       'vIPI',

        'imposto-pis-cst'           'imposto/PIS'                       'CST',

        'imposto-cofins-cst'        'imposto/COFINS'                    'CST',

        'prod-vfrete'               'prod/vFrete'                       '',
        'prod-vseg'                 'prod/vSeg'                         '',
        'prod-voutro'               'prod/vOutro'                       '',
        'prod-cprod'                'prod/cProd'                        '',
        'prod-ceantrib'             'prod/cEANTrib'                     '',
        'prod-cean'                 'prod/cEAN'                         ''.


      DATA(v_base_path) =
          |infNFe/det nItem="{ v_nitem }"|.

      LOOP AT t_map INTO s_map.
        DATA(v_path) = |{ v_base_path }/{ s_map-xml_path }|.

        ASSIGN COMPONENT s_map-itab_path OF STRUCTURE s_det TO <nfe_comp>.
        CHECK ( sy-subrc IS INITIAL ).

        IF ( s_map-skip_to IS INITIAL ).
          <nfe_comp> = get_value( v_path ).
*Remove non numeric values to avoid dump
          IF s_map-itab_path EQ 'prod-xped'.
            lv_xped = <nfe_comp>.
            REPLACE ALL OCCURRENCES OF REGEX '[A-Z]' IN lv_xped WITH ''.
            <nfe_comp> = lv_xped.
          ENDIF.
        ELSE. "skip to
          <nfe_comp> =
            get_value_skip(
                iv_path = v_path
                iv_skip_to = s_map-skip_to
            ).
        ENDIF.
      ENDLOOP.

      APPEND
        s_det TO gs_nfe_data-infnfe-det.
    ENDDO.
  ENDMETHOD. "build_xml_data


  METHOD get_nfe_data.
*main data
    IF ( gs_nfe_data IS INITIAL ).
      build_xml_data( ).
    ENDIF.

*secondary data. Fill only if requested.
    IF  (
                iv_full     = abap_true
            AND gv_is_full  = abap_false
        ).
*lazy load of the data which is used only if validating the NFe
      std_data(  ).

      gv_is_full = abap_true.
    ENDIF.

*reference data. Fill only if requested.
    IF ( iv_with_ref = abap_true ).
      gs_nfe_data-ref =
          build_ref_data( gs_nfe_data-infnfe-ide-tpnf ).
    ENDIF.

*expose the data
    rs_nfe_data = gs_nfe_data.
  ENDMETHOD.


  METHOD item_fetch.
    DATA(s_nfe_data) = get_nfe_data( ).
    TRY.
        rs_det =
            s_nfe_data-infnfe-det[
                prod-nitem = zcl_mm_nfe=>mid_id( iv_id )
            ].
      CATCH cx_sy_itab_line_not_found.
        IF 1 = 1. ENDIF.
    ENDTRY.
  ENDMETHOD.


  METHOD std_data.
*
***
* Purchase Order
*
    DATA: lv_xped TYPE string.

    LOOP AT gs_nfe_data-infnfe-det REFERENCE INTO DATA(s_det).
      SELECT SINGLE
            *
         FROM zcdsmm_i_xml_hist_it
         WHERE chave = @gv_accesskey
           AND id = @s_det->prod-nitem
         INTO @s_det->hist_it.

*Remove non numeric values to avoid dump
      lv_xped = s_det->hist_it-xped.
      REPLACE ALL OCCURRENCES OF REGEX '[A-Z]' IN lv_xped WITH ''.
      s_det->hist_it-xped = lv_xped.

      SELECT SINGLE
          *
        FROM ekko
        WHERE ebeln = @s_det->hist_it-xped      "<-- this PO is the one that counts. Can come from the
          AND loekz IS INITIAL
        INTO @s_det->po-ekko.                   "    XML or can be entered by the user.

      gv_doc_type =
        SWITCH #(
            s_det->po-ekko-bstyp
            WHEN 'L' THEN 'PR'
            ELSE 'PO'
        ).

      DATA lv_ebelp TYPE ekpo-ebelp.
      lv_ebelp = s_det->hist_it-nitemped.
      SELECT SINGLE
          *
        FROM ekpo
        WHERE ebeln = @s_det->po-ekko-ebeln
*          AND ebelp = @s_det->hist_it-nitemped
          AND ebelp = @lv_ebelp
          AND loekz IS INITIAL
        INTO @s_det->po-ekpo.

      SELECT
          *
        FROM ekkn
        WHERE ebeln = @s_det->po-ekko-ebeln
*          AND ebelp = @s_det->hist_it-nitemped
          AND ebelp = @lv_ebelp
          AND loekz IS INITIAL
        INTO @s_det->po-ekkn
        UP TO 1 ROWS.
      ENDSELECT.

*
***
* Vendor
*
      SELECT SINGLE
          *
        FROM lfa1
        WHERE lifnr = @s_det->po-ekko-lifnr
        INTO @s_det->po-lfa1.


********************************************************************************************
********************************************************************************************
***
* Valores da PO ou PR
***


      CASE gv_doc_type.
        WHEN 'PO'.

          SELECT
              *
            FROM prcd_elements
            WHERE knumv = @s_det->po-ekko-knumv
              AND kposn = @s_det->po-ekpo-ebelp
            INTO TABLE @s_det->po-t_prcd_elements.

          SELECT
              *
            FROM eket
            WHERE ebeln = @s_det->po-ekko-ebeln
              AND ebelp = @lv_ebelp
            INTO @s_det->po-eket
            UP TO 1 ROWS.
          ENDSELECT.

****
* PO Values
*
          s_det->* = vlrs_calc_po( s_det->* ).



*####################################################################################
        WHEN 'PR'.
          CALL FUNCTION 'BAPI_SAG_GETDETAIL'
            EXPORTING
              purchasingdocument = s_det->po-ekko-ebeln
              item_data          = abap_true
              condition_data     = abap_true
            TABLES
              item_condition     = s_det->pr-t_item_condition.

          DELETE s_det->pr-t_item_condition
            WHERE deletion_ind = abap_true.

          DELETE s_det->pr-t_item_condition
            WHERE item_no <> lv_ebelp.

*para a quantidade
          SELECT
              *
            FROM eket
            WHERE ebeln = @s_det->po-ekko-ebeln
              AND ebelp = @lv_ebelp
              AND  wemng < eket~menge
            ORDER BY eindt
            INTO TABLE @s_det->po-t_eket.
          IF ( s_det->po-eket IS INITIAL ).
            SELECT
                *
              FROM eket
              WHERE ebeln = @s_det->po-ekko-ebeln
                AND ebelp = @lv_ebelp
              ORDER BY eindt
              INTO TABLE @s_det->po-t_eket.
          ENDIF.

*para a data
          SELECT
              *
            FROM eket
            WHERE ebeln = @s_det->po-ekko-ebeln
              AND ebelp = @lv_ebelp
              AND  wemng < eket~menge
            ORDER BY eindt
            INTO @s_det->po-eket
            UP TO 1 ROWS.
          ENDSELECT.
          IF ( s_det->po-eket IS INITIAL ).
            SELECT
                *
              FROM eket
              WHERE ebeln = @s_det->po-ekko-ebeln
                AND ebelp = @lv_ebelp
              ORDER BY eindt
              INTO @s_det->po-eket
              UP TO 1 ROWS.
            ENDSELECT.
          ENDIF.


****
* Programa de Remessa Values
*
          s_det->* = vlrs_calc_pr( s_det->* ).

      ENDCASE. "GV_DOC_TYPE



*###########################################################################################

****
* Totals
* v_NF (to be used in rule #17 and elsewhere)

      IF ( s_det->imposto-icms-vicmsdeson IS INITIAL ). "sem desoneração
        s_det->v_nf =
            (
                    s_det->vlrs-netwr-amnt
                +   s_det->vlrs-ipi-amnt
                -   s_det->vlrs-descsap-amnt
            ).
      ELSE. "com desoneração
        s_det->v_nf =
          (
                s_det->vlrs-netwr-amnt
            -   s_det->vlrs-icmsdeson-amnt
            -   s_det->vlrs-descsap-amnt
          ).
      ENDIF.

      s_det->v_nf = abs( s_det->v_nf ).

      gs_nfe_data-v_nf += s_det->v_nf.

    ENDLOOP. "gs_nfe_data-infnfe-det

    gs_nfe_data-v_nf = abs( gs_nfe_data-v_nf ).

  ENDMETHOD.


  METHOD build_ref_data.
    CHECK ( gv_is_ref = abap_false ).

***
* NFe referencia
*

    CASE iv_tpnf.
      WHEN '0'. "Inbound

*There is a XML in the eDocument.

        DATA(o_ref) =
            NEW zcl_mm_nfe(
                iv_accesskey =
                    CONV #(
                        gs_nfe_data-infnfe-ide-nfref-refnfe
                )
                iv_is_ref = abap_true
            ).

        DATA(s_ref_data) = o_ref->get_nfe_data(
*            iv_full = abap_true
        ).
        CHECK ( NOT s_ref_data-xml_str IS INITIAL ).

        rs_ref =
            VALUE #(
*                docnum = s_ref_data-infnfe-ide-cnf
                nfenum = s_ref_data-infnfe-ide-nnf
                nftot = s_ref_data-infnfe-total-icmstot-vnf
                pstdat =
                        |{ s_ref_data-infnfe-ide-dhemi(4) }|
                    &&  |{ s_ref_data-infnfe-ide-dhemi+5(2) }|
                    &&  |{ s_ref_data-infnfe-ide-dhemi+8(2) }|
                xml_str = s_ref_data-xml_str
            ).

        RETURN.

      WHEN '1'. "Outbound

*There is no XML in the eDocument

        DATA(v_refnfe) = gs_nfe_data-infnfe-ide-nfref-refnfe.

        TRY.
            SELECT SINGLE
                doc~nfenum,
                doc~pstdat,
                doc~nftot,
                doc~docnum
              INTO CORRESPONDING FIELDS OF @rs_ref
              FROM j_1bnfe_active   AS act
              JOIN j_1bnfdoc        AS doc
                ON doc~docnum = act~docnum
              WHERE act~regio       = @v_refnfe(2)      "2 primeiros dígitos
                AND act~nfyear      = @v_refnfe+2(2)    "3º e 4º dígito
                AND act~nfmonth     = @v_refnfe+4(2)    "5º e 6º dígito
                AND act~stcd1       = @v_refnfe+6(14)   "7º ao 20º dígito
                AND act~model       = @v_refnfe+20(2)   "21º e 22º dígito
                AND act~serie       = @v_refnfe+22(3)   "23º ao 25º dígito
                AND act~nfnum9      = @v_refnfe+25(9)   "26º ao 34º dígito
                AND act~docnum9     = @v_refnfe+34(9)   "35º ao 43º dígito
                AND act~cdv         = @v_refnfe+43(1).  "44º dígito
          CATCH cx_sy_range_out_of_bounds.
        ENDTRY.

        RETURN.
    ENDCASE. "iv_tpnf
  ENDMETHOD.


  METHOD get_taxval_komv.
    CHECK (
        ( NOT is_det-po-ekko IS INITIAL )
        AND
        ( NOT is_det-po-ekpo IS INITIAL )
        AND
        ( NOT is_det-po-lfa1 IS INITIAL )
    ).

    CALL FUNCTION 'ZMM_GET_TAXVAL_PO_PRICING'
      EXPORTING
        taxcom =
                 VALUE taxcom(
                   bukrs = is_det-po-ekko-bukrs
                   budat = is_det-po-ekko-bedat
                   bldat = is_det-po-ekko-bedat
                   waers = is_det-po-ekko-waers
                   hwaer = is_det-po-ekko-waers
                   kposn = is_det-po-ekpo-ebelp
                   mwskz = is_det-po-ekpo-mwskz
                   shkzg = 'H' "fixo"
*                   wrbtr = is_det-po-ekpo-netwr
                   wrbtr =
                    (
                        (
                            is_det-po-ekpo-netwr
                            /
                            is_det-po-ekpo-menge
                        )
                        *
                        is_det-vlrs-menge
                    )
                   xmwst = abap_true
                   txjcd = is_det-po-ekpo-txjcd
                   lifnr = is_det-po-ekko-lifnr
                   ekorg = is_det-po-ekko-ekorg
                   matnr = is_det-po-ekpo-matnr
                   werks = is_det-po-ekpo-werks
                   matkl = is_det-po-ekpo-matkl
                   meins = is_det-po-ekpo-meins
                   mglme =
                    COND #(
                        WHEN iv_qt_parc IS SUPPLIED
                        THEN iv_qt_parc
                        ELSE is_det-vlrs-menge
                    )
                   mtart = is_det-po-ekpo-mtart
                   land1 = 'BR' "fixo"
                 )
        ekko   = is_det-po-ekko
        ekpo   = is_det-po-ekpo
        lfa1   = is_det-po-lfa1
      TABLES
        komv   = rt_komv.
  ENDMETHOD.


  METHOD validate_item.
*force the full data load
    get_nfe_data( iv_full = abap_true ).

*invoke the validator
    rt_log =
        zcl_mm_nfe_validator=>validate_item(
            io_nfe = me
            iv_id = iv_id
        ).

*find the last seq
    SELECT
        MAX( seq ) AS lastseq
      FROM zcdsmm_i_log_erros
      WHERE chave   = @gv_accesskey
        AND id      = @iv_id
      INTO @DATA(v_last_seq).

*put a seq number in each new log
    LOOP AT rt_log REFERENCE INTO DATA(r_log).
      ADD 1 TO v_last_seq.

      r_log->seq = v_last_seq.
    ENDLOOP.

  ENDMETHOD.


  METHOD short_id.
    rv_id = iv_id.
    SHIFT rv_id LEFT DELETING LEADING '0'.
  ENDMETHOD.


  METHOD mid_id.
    rv_id = iv_id.
  ENDMETHOD.


  METHOD get_prcd_element.
    TRY.
        rs_prcd_element =
            is_det-po-t_prcd_elements[
                kappl = 'M'
                kschl = iv_kschl
            ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.


  METHOD get_item_condition.
    TRY.
        rs_item_condition =
            is_det-pr-t_item_condition[
                item_no = is_det-po-ekpo-ebelp
                cond_type = iv_cond_type
            ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.


  METHOD vlrs_calc_po.

    rs_det = is_det.


***
* Menge
    rs_det-vlrs-menge = rs_det-po-ekpo-menge.

    IF ( rs_det-prod-qcom > rs_det-vlrs-menge ).
      DATA(v_qt_parc) = rs_det-po-ekpo-menge.
    ELSE.
      v_qt_parc = rs_det-prod-qcom.
    ENDIF.

*
***
* TAXBRA-KOMV
*
    rs_det-po-t_komv =
        get_taxval_komv(
            is_det = rs_det
            iv_qt_parc = v_qt_parc
        ).


***
* commons
*
    DATA: v_dec2 TYPE p DECIMALS 2.

    DEFINE get_prcd_element.
      DATA(s_&1) =
          get_prcd_element(
              is_det = rs_det
              iv_kschl = &2
          ).
    end-of-definition.

    get_prcd_element:
        pbxx 'PBXX',
        zcic 'ZCIC',
        ziic 'ZIIC',
        zcip 'ZCIP',
        ziip 'ZIIP',
        zcrd 'ZCRD',
        zird 'ZIRD',
        zdev 'ZDEV',
        zde_ 'ZDE%'.


***
* Netpr
*
    v_dec2 =
        (
            s_pbxx-kbetr
            /
            COND #(
                WHEN s_pbxx-kpein <> 0
                THEN s_pbxx-kpein
                ELSE 1
           )
        ).
*
    rs_det-vlrs-netpr-amnt = v_dec2.


***
* Icms-Aliq
*
    IF ( NOT s_zcic-kbetr IS INITIAL ).
      v_dec2 = s_zcic-kbetr.
    ELSE.
      v_dec2 = s_ziic-kbetr.
    ENDIF.

    rs_det-vlrs-icms-aliq = v_dec2.


***
* Ipi-Aliq
*
    IF ( NOT s_zcip-kbetr IS INITIAL ).
      v_dec2 = s_zcip-kbetr.
    ELSE.
      v_dec2 = s_ziip-kbetr.
    ENDIF.

    rs_det-vlrs-ipi-aliq = v_dec2.


***
* Icms-Amnt
*
    IF ( NOT s_zcic-kwert IS INITIAL ).
      v_dec2 = s_zcic-kwert.
    ELSE.
      v_dec2 = s_ziic-kwert.
    ENDIF.

    rs_det-vlrs-icms-amnt =
        abs(
            ( v_dec2 / rs_det-vlrs-menge * v_qt_parc )
        ).


***
* Icms_Deson-Amnt
*
    IF ( rs_det-imposto-icms-vicmsdeson <> 0 ).
      rs_det-vlrs-icmsdeson-amnt = rs_det-vlrs-icms-amnt.
    ENDIF.


***
* Icms-BC
*
    IF ( NOT s_zcic-kwert IS INITIAL ).
      v_dec2 = s_zcrd-kwert.
    ELSE.
      v_dec2 = s_zird-kwert.
    ENDIF.

    rs_det-vlrs-icms-bc =
        ( v_dec2 / rs_det-vlrs-menge * v_qt_parc ).


***
* Ipi-Amnt
*
    IF ( NOT s_zcip-kwert IS INITIAL ).
      v_dec2 = s_zcip-kwert.
    ELSE.
      v_dec2 = s_ziip-kwert.
    ENDIF.

    rs_det-vlrs-ipi-amnt =
        ( v_dec2 / rs_det-vlrs-menge * v_qt_parc ).


***
* DescSAP-Amnt
*
    IF ( NOT s_zdev-kwert IS INITIAL ).
      v_dec2 = s_zdev-kwert.
    ELSE.
      v_dec2 = s_zde_-kwert.
    ENDIF.

    rs_det-vlrs-descsap-amnt = abs( v_dec2 ).


***
* Eindt
*
    rs_det-vlrs-eindt = rs_det-po-eket-eindt.


***
* Netwr
*
    v_dec2 =
        (
            v_qt_parc
            *
            (
                    s_pbxx-kbetr
                /   s_pbxx-kpein
            )
        ).

    rs_det-vlrs-netwr-amnt = v_dec2.

  ENDMETHOD. "PO


  METHOD vlrs_calc_pr.
    rs_det = is_det.


***
* Menge
    rs_det-vlrs-menge = rs_det-po-ekpo-menge.

*    LOOP AT rs_det-po-t_eket INTO DATA(s_eket).
*      rs_det-vlrs-menge +=
*          ( s_eket-menge - s_eket-wemng ).
*    ENDLOOP.
*
    IF ( rs_det-prod-qcom > rs_det-vlrs-menge ).
      DATA(v_qt_parc) = rs_det-po-ekpo-ktmng.
    ELSE.
      v_qt_parc = rs_det-prod-qcom.
    ENDIF.

*
***
* TAXBRA-KOMV
*
    rs_det-po-t_komv =
        get_taxval_komv(
            is_det = rs_det
            iv_qt_parc = v_qt_parc
        ).

***
* commons
*
    DATA: v_dec2 TYPE p DECIMALS 2.

    DEFINE get_item_condition.
      DATA(s_&1) =
          get_item_condition(
              is_det = rs_det
              iv_cond_type = &2
          ).
    end-of-definition.

    DEFINE get_konv.
      TRY.
          DATA(s_&1) =
              rs_det-po-t_komv[
                  kschl = &2
              ].
           CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    end-of-definition.

    get_item_condition:
        zz00 'ZZ00',
        zicc 'ZICC',
        zicm 'ZICM',
        zip1 'ZIP1',
        zdev 'ZDEV',
        zde_ 'ZDE%'.

    get_konv:
        bx13 'BX13',
        bx12 'BX12',
        bx10 'BX10',
        bx23 'BX23'.

***
* NETPR
*
    v_dec2 =
        (
            s_zz00-cond_value
            /
            COND #(
                WHEN s_zz00-cond_p_unt <> 0
                THEN s_zz00-cond_p_unt
                ELSE 1
           )
        ).
*

    rs_det-vlrs-netpr-amnt = v_dec2.

***
* Icms-Aliq
*
    v_dec2 =
        (
            s_zicc-cond_value
            +
            s_zicm-cond_value
        ).

    rs_det-vlrs-icms-aliq = abs( v_dec2 ).


***
* Ipi-Aliq
*
    v_dec2 = s_zip1-cond_value.

    rs_det-vlrs-ipi-aliq = v_dec2.


***
* Icms-Amnt
*
    IF ( NOT rs_det-vlrs-icms-aliq IS INITIAL ).
      v_dec2 = s_bx13-kwert.

      rs_det-vlrs-icms-amnt =
       ( v_dec2 / rs_det-vlrs-menge * v_qt_parc ).
    ENDIF.


***
* Icms_Deson-Amnt
*
    IF ( rs_det-imposto-icms-vicmsdeson <> 0 ).
      rs_det-vlrs-icmsdeson-amnt = rs_det-vlrs-icms-amnt.
    ENDIF.


***
* Icms-BC
*
    IF ( NOT s_bx12-kwert IS INITIAL ).
      v_dec2 = s_bx12-kwert.
    ELSE.
      v_dec2 = s_bx10-kwert.
    ENDIF.

    rs_det-vlrs-icms-bc =
        ( v_dec2 / rs_det-vlrs-menge * v_qt_parc ).


***
* Ipi-Amnt
*
    IF ( NOT rs_det-vlrs-ipi-aliq IS INITIAL ).
      v_dec2 = s_bx23-kwert.

      rs_det-vlrs-ipi-amnt =
        ( v_dec2 / rs_det-vlrs-menge * v_qt_parc ).
    ENDIF.


***
* DescSAP-Amnt
*
    IF ( NOT s_zdev-cond_value IS INITIAL ).
      v_dec2 = s_zdev-cond_value.
    ELSE.
      v_dec2 = s_zde_-cond_value.
    ENDIF.

    rs_det-vlrs-descsap-amnt = v_dec2.


***
* Eindt
*
    rs_det-vlrs-eindt = rs_det-po-eket-eindt.


***
* Netwr
*
    v_dec2 =
        (
            v_qt_parc
            *
            (
                    s_zz00-cond_value
                /   s_zz00-cond_p_unt
            )
        ).

*
    rs_det-vlrs-netwr-amnt = v_dec2.

  ENDMETHOD. "PR
ENDCLASS.
