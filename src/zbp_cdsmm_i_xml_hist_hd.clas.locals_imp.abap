CLASS lhc_xml_hd DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS:
      _determine_header_status
        IMPORTING
          iv_chave         TYPE zcdsmm_i_xml_hist_hd-chave
        RETURNING
          VALUE(rv_status) TYPE zcdsmm_i_xml_hist_hd-status,

      fill FOR DETERMINE ON MODIFY
        IMPORTING keys FOR xml_hd~fill,

      validate_item
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_it~validateitem
        RESULT
                  et_xml_it,
      validate
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_hd~validate,

      status_change
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_hd~statuschange,

      xped_change
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_it~xpedchange,

      nitemped_change
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_it~nitempedchange,

      pin_change
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_hd~pinchange,

      actreq_change
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_hd~actreqchange,

      file
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_hd~file,

      div
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_hd~div,

      obs_send_action
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_it~obssend,

      obsh_send_action
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_hd~obshsend,

      nfwrite
        FOR MODIFY
        IMPORTING keys
                    FOR ACTION xml_hd~nfwrite.
ENDCLASS.

CLASS lhc_xml_hd IMPLEMENTATION.

  METHOD fill.
***
* When creating a XML Hist entity (root) its key is an NFe access key. The necessary data
* to fill up the entity is inside the XML file. Here we open the XML file and fill up the
* entity with the content. This determination is triggered at the creation of the header,
* which by the way is the root entity. The items must also be extracted from the XML and this
* is done here too.
* This data is the base for the object page in the app.
***


    READ ENTITIES
        OF zcdsmm_i_xml_hist_hd
        IN LOCAL MODE
        ENTITY xml_hd
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(t_xml_hd).

    LOOP AT t_xml_hd REFERENCE INTO DATA(r_xml_hd).
*
      DATA(o_nfe) = NEW zcl_mm_nfe( r_xml_hd->chave ).
      DATA(nfe) =
        o_nfe->get_nfe_data(
*            iv_full = abap_true
            iv_with_ref = abap_true
        ).

      r_xml_hd->fileraw = nfe-file_raw.
      r_xml_hd->xmlstr = nfe-xml_str.
      r_xml_hd->refxmlstr = nfe-ref-xml_str.
      r_xml_hd->credat = sy-datum.
      r_xml_hd->cnpj = nfe-infnfe-emit-cnpj.
      r_xml_hd->pin =
        SWITCH #(
            nfe-infnfe-emit-enderemit-uf
            WHEN 'AM' THEN '1'
            ELSE nfe-infnfe-emit-crt
        ).

*
*fill a table of items
      DATA t_xml_it TYPE STANDARD TABLE OF zcdsmm_i_xml_hist_it.
      CLEAR t_xml_it.
      LOOP AT nfe-infnfe-det REFERENCE INTO DATA(r_det).
        APPEND
            VALUE #(
                chave = r_xml_hd->chave
                id = r_det->prod-nitem
                xped = r_det->prod-xped
                nitemped = r_det->prod-nitemped
            ) TO t_xml_it.
      ENDLOOP.

*update the header attribute fields
      MODIFY ENTITIES
          OF zcdsmm_i_xml_hist_hd
          IN LOCAL MODE
          ENTITY xml_hd
              UPDATE SET FIELDS WITH VALUE #(
                  (
                      chave = r_xml_hd->chave
                      fileraw = r_xml_hd->fileraw
                      xmlstr = r_xml_hd->xmlstr
                      refxmlstr = r_xml_hd->refxmlstr
                      credat = r_xml_hd->credat
                      cnpj = r_xml_hd->cnpj
                      pin = r_xml_hd->pin
                  )
              ).

*here the items are created by relation from the header
      MODIFY ENTITIES
          OF zcdsmm_i_xml_hist_hd
          ENTITY xml_hd
              CREATE BY \_items
              FIELDS ( chave id xped nitemped )
              WITH VALUE #(
                  (
                      chave = r_xml_hd->chave
                      %target =
                          VALUE #(
                              FOR xml_it IN t_xml_it
                              (
                                  chave = xml_it-chave
                                  id = xml_it-id
                                  xped = xml_it-xped
                                  nitemped = xml_it-nitemped
                              )
                          )
                  )
              )
           REPORTED DATA(t_rep)
           FAILED DATA(t_failed).
    ENDLOOP.

  ENDMETHOD.

  METHOD validate_item.
***
* The error messages points to items. So the validation is by item. But from the
* user point of view the validation if for a Header (a NFe). So the app button
* calls the 'validate' action, which by it´s turn calls this one for each item.
***

    READ ENTITIES
        OF zcdsmm_i_xml_hist_hd
        IN LOCAL MODE
        ENTITY xml_it
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(t_xml_it).

    DATA o_nfe TYPE REF TO zcl_mm_nfe.

    LOOP AT t_xml_it REFERENCE INTO DATA(r_it).
*read the current ones
      READ ENTITIES
        OF zcdsmm_i_xml_hist_hd
        IN LOCAL MODE
        ENTITY xml_it
        BY \_errors
        FIELDS (
            chave
            id
            seq
            tagxmlhdr
            tagxmlitem
            valorxml
            valorsap
            inactive
        )
        WITH VALUE #(
            (
                chave = r_it->chave
                id = r_it->id
            )
        )
        RESULT DATA(t_old).

      DELETE t_old WHERE inactive = abap_true.

***
* validate it
*
      IF ( NOT o_nfe IS BOUND ).
        o_nfe = NEW #( r_it->chave ).
      ENDIF.

      DATA(t_errors) = o_nfe->validate_item( r_it->id ).

***
* inactivate the ones that were resolved
*
      LOOP AT t_old REFERENCE INTO DATA(r_old).
        DATA(v_tabix_old) = sy-tabix.

*was it resolved? Let´s look for it into the new ones
        READ TABLE t_errors
            TRANSPORTING NO FIELDS
            WITH KEY
                chave = r_old->chave
                id = r_old->id
                tagxmlhdr = r_old->tagxmlhdr
                tagxmlitem = r_old->tagxmlitem
                valorxml = r_old->valorxml
                valorsap = r_old->valorsap.

        IF ( NOT sy-subrc IS INITIAL ).
*this error was gone. Let´s inactivate it
          MODIFY ENTITIES
              OF zcdsmm_i_xml_hist_hd
              ENTITY errors
              UPDATE
                FIELDS ( inactive )
              WITH
                  VALUE #(
                    (
                      chave = r_old->chave
                      id = r_old->id
                      seq = r_old->seq
                      inactive = abap_true
                    )
                  ).

*remove it from the list of current (old) errors
          DELETE t_old INDEX v_tabix_old.
        ENDIF.
      ENDLOOP. "t_old

***
* Now let´s erase and recreate all the new ones
*
      MODIFY ENTITIES
          OF zcdsmm_i_xml_hist_hd
          ENTITY errors
          DELETE FROM
              VALUE #(
                FOR old IN t_old
                (
                  chave = old-chave
                  id = old-id
                  seq = old-seq
                )
              )
          MAPPED mapped
          REPORTED reported
          FAILED failed.

      MODIFY ENTITIES
          OF zcdsmm_i_xml_hist_hd
          ENTITY xml_it
          CREATE BY \_errors
          FIELDS (
                  chave id seq
                  statusvalid
                  tagxmlhdr
                  tagxmlitem
                  nnf
                  itemxml
                  pedido
                  itempedido
                  valorxml
                  valorsap
                  texto
              )
          WITH VALUE #(
              (
                  chave = r_it->chave
                  id = r_it->id
                  %target =
                      VALUE #(
                        FOR error IN t_errors
                          (
                              chave       = r_it->chave
                              id          = r_it->id
                              seq         = error-seq
                              statusvalid = error-statusvalid
                              texto       = error-texto
                              tagxmlhdr   = error-tagxmlhdr
                              tagxmlitem  = error-tagxmlitem
                              nnf         = error-nnf
                              itemxml     = error-itemxml
                              pedido      = error-pedido
                              itempedido  = error-itempedido
                              valorxml    = error-valorxml
                              valorsap    = error-valorsap
                          )
                      )
              )
          )
          MAPPED mapped
          REPORTED reported
          FAILED failed.


*set the status for the item
      DATA(v_item_has_error) = abap_false.
      DATA(v_item_has_warning) = abap_false.

      LOOP AT t_errors INTO DATA(s_error).
        CASE s_error-statusvalid.
          WHEN zcl_mm_nfe=>c_status_valid-incorrect.
            v_item_has_error = abap_true.
          WHEN zcl_mm_nfe=>c_status_valid-warning.
            v_item_has_warning = abap_true.
        ENDCASE.
      ENDLOOP.

      MODIFY ENTITIES
          OF zcdsmm_i_xml_hist_hd
          ENTITY xml_it
          UPDATE
          FIELDS ( statusvalid )
          WITH VALUE #(
              (
                  chave = r_it->chave
                  id = r_it->id
                  statusvalid =
                      COND #(
                          WHEN ( v_item_has_error = abap_true )
                              THEN zcl_mm_nfe=>c_status_valid-incorrect
                          WHEN ( v_item_has_warning = abap_true )
                              THEN zcl_mm_nfe=>c_status_valid-incorrect
                          ELSE zcl_mm_nfe=>c_status_valid-ok
                      )
              )
          )
          MAPPED mapped
          REPORTED reported
          FAILED failed.

      APPEND
        CORRESPONDING #( r_it->* ) TO et_xml_it.
    ENDLOOP. "t_xml_it

  ENDMETHOD. "validate_item

  METHOD validate. "(header)
***
* The error messages points to items. So the validation is by item. But from the
* user point of view the validation if for a Header (a NFe). So the app button
* calls this action, which calls the validate_item action for each item.
***

    READ ENTITIES
        OF zcdsmm_i_xml_hist_hd
        IN LOCAL MODE
        ENTITY xml_hd
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(t_xml_hd).

    LOOP AT t_xml_hd REFERENCE INTO DATA(r_hd).
*
      READ ENTITIES
          OF zcdsmm_i_xml_hist_hd
          IN LOCAL MODE
          ENTITY xml_hd
          BY \_items
          ALL FIELDS
          WITH VALUE #( ( chave = r_hd->chave ) )
          RESULT DATA(t_xml_it).

      CHECK ( NOT t_xml_it IS INITIAL ). "there are xml´s without data...

      LOOP AT t_xml_it REFERENCE INTO DATA(r_it).
        MODIFY ENTITIES
            OF zcdsmm_i_xml_hist_hd
            IN LOCAL MODE
            ENTITY xml_it
            EXECUTE validateitem
              FROM
                VALUE #(
                  (
                    chave = r_it->chave
                    id = r_it->id
                  )
                )
            RESULT DATA(t_result)
            MAPPED DATA(mapped1)
            REPORTED DATA(reported1)
            FAILED DATA(failed1).

        DATA t_result_all LIKE t_result.
        APPEND LINES OF t_result TO t_result_all.
      ENDLOOP. "it

*re-read it to see the status
      READ ENTITIES
          OF zcdsmm_i_xml_hist_hd
          IN LOCAL MODE
          ENTITY xml_hd
          BY \_items
          ALL FIELDS
          WITH VALUE #( ( chave = r_hd->chave ) )
          RESULT t_xml_it.

      LOOP AT t_xml_it REFERENCE INTO r_it.
        IF ( r_it->statusvalid = zcl_mm_nfe=>c_status_valid-incorrect ).
          DATA(v_header_has_error) = abap_true .
        ENDIF.
        IF ( r_it->statusvalid = zcl_mm_nfe=>c_status_valid-warning ).
          DATA(v_header_has_warning) = abap_true .
        ENDIF.
      ENDLOOP.
*
*set the status for the header
      MODIFY ENTITIES
          OF zcdsmm_i_xml_hist_hd
          ENTITY xml_hd
          UPDATE
          FIELDS ( statusvalid )
          WITH VALUE #(
              (
                  chave = r_hd->chave
                  statusvalid =
                    COND #(
                        WHEN ( v_header_has_error = abap_true )
                          THEN zcl_mm_nfe=>c_status_valid-incorrect
                        WHEN ( v_header_has_warning = abap_true )
                          THEN zcl_mm_nfe=>c_status_valid-warning
                        ELSE zcl_mm_nfe=>c_status_valid-ok
                    )
              )
          )
          MAPPED mapped
          REPORTED reported
          FAILED failed.
    ENDLOOP. "hd
  ENDMETHOD.

  METHOD status_change.

*register the release, reject or undo in the Log entity

*read the header data
    READ ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(t_hd).

    LOOP AT keys INTO DATA(s_key).

      DATA(s_hd) = t_hd[ chave = s_key-chave ].

*check the last seq
      SELECT SINGLE
            MAX( \_logh-seq )
          FROM zcdsmm_i_xml_hist_hd
          WHERE chave = @s_key-chave
          INTO @DATA(v_next_seq).

      v_next_seq += 1.


*update the hd status
      DATA(v_status) =
        SWITCH #(
            s_key-%param-action
            WHEN 'L'
                THEN zcl_mm_nfe=>c_status-released
            WHEN 'J'
                THEN zcl_mm_nfe=>c_status-rejected
            WHEN 'U'
                THEN zcl_mm_nfe=>c_status-undone
        ).

      MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        UPDATE
        FIELDS ( status )
        WITH VALUE #(
            (
              chave = s_key-chave
              status = v_status
            )
        )
        MAPPED DATA(mapped1)
        REPORTED DATA(reported1)
        FAILED DATA(failed1).


*register the log
      MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        CREATE BY \_logh
        FIELDS (
              chave seq
              aedat
              aezet
              aenam
              statusvalid
              oldvalue
              newvalue
              message
            )
        WITH VALUE #(
            (
              chave = s_key-chave
              %target =
                VALUE #(
                    (
                      chave = s_key-chave
                      seq = v_next_seq
                      aedat = sy-datum
                      aezet = sy-uzeit
                      aenam = sy-uname
                      camposap = 'STATUS'
                      statusvalid = s_hd-statusvalid
                      oldvalue = s_hd-status
                      newvalue = v_status
                      message = s_key-%param-message
                    )
                )

            )
        )
        MAPPED mapped1
        REPORTED reported1
        FAILED failed1.

    ENDLOOP. "hd

  ENDMETHOD.

  METHOD file.
*archive or unarchive an entry

    LOOP AT keys INTO DATA(s_key).
      CASE s_key-%param-action.
        WHEN 'F'.
          DATA(v_status) = zcl_mm_nfe=>c_status-archived.
          DATA(v_archive) = abap_true.
        WHEN 'U'.
          v_status = zcl_mm_nfe=>c_status-undefined.
          v_archive = abap_false.
      ENDCASE.

*set HD "ARCHIVE" flag to true or false
      MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        UPDATE
        FIELDS ( archive aenam status )
        WITH VALUE #(
            (
              chave = s_key-chave
              archive = v_archive
              aenam = sy-uname
              status = v_status
            )
        )
        MAPPED DATA(mapped1)
        REPORTED DATA(reported1)
        FAILED DATA(failed1).

*set IT status as archived
      READ ENTITIES
          OF zcdsmm_i_xml_hist_hd
          ENTITY xml_hd
          BY \_items
          ALL FIELDS
          WITH VALUE #(
              (
                  chave = s_key-chave
              )
          )
          RESULT DATA(t_item).

      MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_it
        UPDATE
        FIELDS ( status )
        WITH VALUE #(
            FOR s_it IN t_item
            (
              chave = s_it-chave
              id = s_it-id
              status = v_status
            )
        )
        MAPPED mapped1
        REPORTED reported1
        FAILED failed1.
    ENDLOOP. "keys

  ENDMETHOD.


  METHOD div.
*archive or unarchive an entry

    LOOP AT keys INTO DATA(s_key).

*remove the old XML_COD entries
      READ ENTITIES
          OF zcdsmm_i_xml_hist_hd
          ENTITY xml_hd
          BY \_cods
          ALL FIELDS
          WITH VALUE #(
              (
                  chave = s_key-chave
              )
          )
          RESULT DATA(t_cods).

      MODIFY ENTITIES
         OF zcdsmm_i_xml_hist_hd
         ENTITY xml_cod
         DELETE FROM
         VALUE #(
            FOR s_cod IN t_cods
            (
              chave = s_cod-chave
              coddiv = s_cod-coddiv
            )
        )
        MAPPED DATA(mapped1)
        REPORTED DATA(reported1)
        FAILED DATA(failed1).

*fill the XML_COD entries
      SPLIT s_key-%param-message AT ';' INTO TABLE DATA(t_cod).

      MODIFY ENTITIES
          OF zcdsmm_i_xml_hist_hd
          ENTITY xml_hd
              CREATE BY \_cods
              FIELDS ( chave coddiv )
              WITH VALUE #(
                  (
                      chave = s_key-chave
                      %target =
                          VALUE #(
                              FOR xml_cod IN t_cod
                              (
                                  chave = s_key-chave
                                  coddiv = xml_cod
                              )
                          )
                  )
              )
           REPORTED reported1
           FAILED failed1.

    ENDLOOP. "keys

  ENDMETHOD.

  METHOD _determine_header_status.
    READ ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        BY \_items
            FIELDS ( chave id status )
            WITH VALUE #(
                (
                    chave = iv_chave
                )
            )
            RESULT DATA(t_it).

    rv_status = zcl_mm_nfe=>c_status-undefined.

    CHECK ( NOT t_it IS INITIAL ).

    DATA:
      v_all_released TYPE abap_bool VALUE 'X',
      v_all_rejected TYPE abap_bool VALUE 'X',
      v_all_undone   TYPE abap_bool VALUE 'X'.

    LOOP AT t_it INTO DATA(s_it).
*disprove them
      IF ( s_it-status <> zcl_mm_nfe=>c_status-released ).
        v_all_released = abap_false.
      ENDIF.
      IF ( s_it-status <> zcl_mm_nfe=>c_status-rejected ).
        v_all_rejected = abap_false.
      ENDIF.
      IF ( s_it-status <> zcl_mm_nfe=>c_status-undone ).
        v_all_undone = abap_false.
      ENDIF.
    ENDLOOP.

    rv_status = zcl_mm_nfe=>c_status-undefined. "default

    IF ( v_all_released = abap_true ).
      rv_status = zcl_mm_nfe=>c_status-released.
      RETURN.
    ENDIF.

    IF ( v_all_rejected = abap_true ).
      rv_status = zcl_mm_nfe=>c_status-rejected.
      RETURN.
    ENDIF.

    IF ( v_all_undone = abap_true ).
      rv_status = zcl_mm_nfe=>c_status-undone.
      RETURN.
    ENDIF.

    RETURN.
  ENDMETHOD.

  METHOD xped_change.
*    RETURN.

***
* When the user changes the PO number at the object page two things must be done:
* 1) It must be registered a log of the change;
* 2) The item itself must be changed.

*read the item data
    READ ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_it
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(t_item).

    LOOP AT keys INTO DATA(s_key1).
      DATA(s_item) = t_item[ chave = s_key1-chave id = s_key1-id ].

*register the log

*check the last seq
      SELECT SINGLE
            \_lastlog-seq
          FROM zcdsmm_i_xml_hist_it
          WHERE chave = @s_key1-chave
            AND id = @s_key1-id
          INTO @DATA(v_next_seq).

      v_next_seq += 1.

      MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_it
        CREATE BY \_log
        FIELDS (
              chave id seq
              aedat
              aezet
              aenam
              camposap
              xped
              nitemped
              statusvalid
              oldvalue
              newvalue
            )
        WITH VALUE #(
            (
              chave = s_key1-chave
              id = s_key1-id
              %target =
                VALUE #(
                    (
                      chave = s_key1-chave
                      id = s_key1-id
                      seq = v_next_seq
                      aedat = sy-datum
                      aezet = sy-uzeit
                      aenam = sy-uname
                      camposap = 'XPED'
                      xped = s_item-xped
                      nitemped = s_item-nitemped
                      statusvalid = s_item-statusvalid
                      oldvalue = s_item-xped
                      newvalue = s_key1-%param-xped
                    )
                )
            )
        )
        MAPPED mapped
        REPORTED reported
        FAILED failed.

    ENDLOOP.

*and then modify the entity
    MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_it
        UPDATE
        FIELDS ( xped )
        WITH VALUE #(
            FOR s_key IN keys
            (
              chave = s_key-chave
              id = s_key-id
              xped = s_key-%param-xped
            )
        )
        MAPPED mapped
        REPORTED reported
        FAILED failed.

*    LOOP AT keys INTO DATA(s_key2).
*      UPDATE ztmm_xml_hist_it
*          SET n_item_ped = s_key2-%param-xped
*          WHERE chave = s_key2-chave
*            AND id = s_key2-id.
*    ENDLOOP.

  ENDMETHOD.

  METHOD nitemped_change.
***
* When the user changes the PO number at the object page two things must be done:
* 1) It must be registered a log of the change;
* 2) The item itself must be changed.
* (simliar to the above one)

*read the item data
    READ ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_it
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(t_item).

    LOOP AT keys INTO DATA(s_key1).
      DATA(s_item) = t_item[ chave = s_key1-chave id = s_key1-id ].

*register the log

*check the last seq
      SELECT SINGLE
            \_lastlog-seq
          FROM zcdsmm_i_xml_hist_it
          WHERE chave = @s_key1-chave
            AND id = @s_key1-id
          INTO @DATA(v_next_seq).

      v_next_seq += 1.

      MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_it
        CREATE BY \_log
        FIELDS (
              chave id seq
              aedat
              aezet
              aenam
              camposap
              xped
              nitemped
              statusvalid
              oldvalue
              newvalue
            )
        WITH VALUE #(
            (
              chave = s_key1-chave
              id = s_key1-id
              %target =
                VALUE #(
                    (
                      chave = s_key1-chave
                      id = s_key1-id
                      seq = v_next_seq
                      aedat = sy-datum
                      aezet = sy-uzeit
                      aenam = sy-uname
                      camposap = 'NITEMPED'
                      xped = s_item-xped
                      nitemped = s_item-nitemped
                      statusvalid = s_item-statusvalid
                      oldvalue = s_item-nitemped
                      newvalue = s_key1-%param-nitemped
                    )
                )
            )
        )
        MAPPED mapped
        REPORTED reported
        FAILED failed.

    ENDLOOP.

*and then modify the entity
    MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_it
        UPDATE
        FIELDS ( nitemped )
        WITH VALUE #(
            FOR s_key IN keys
            (
              chave = s_key-chave
              id = s_key-id
              nitemped = s_key-%param-nitemped
            )
        )
        MAPPED mapped
        REPORTED reported
        FAILED failed.
  ENDMETHOD.

  METHOD obs_send_action.

    LOOP AT keys INTO DATA(s_key).
      MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_it
        CREATE BY \_obs
        FIELDS (
              chave id
              aedat
              aezet
              aenam
              message
            )
        WITH VALUE #(
            (
              chave = s_key-chave
              id = s_key-id
              %target =
                VALUE #(
                    (
                      chave = s_key-chave
                      id = s_key-id
                      aedat = sy-datum
                      aezet = sy-uzeit
                      aenam = sy-uname
                      message = s_key-%param-obs
                    )
                )
            )
        )
        MAPPED mapped
        REPORTED reported
        FAILED failed.

    ENDLOOP.
  ENDMETHOD.


  METHOD obsh_send_action.

    LOOP AT keys INTO DATA(s_key).
      MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        CREATE BY \_obsh
        FIELDS (
              chave
              aedat
              aezet
              aenam
              message
            )
        WITH VALUE #(
            (
              chave = s_key-chave
              %target =
                VALUE #(
                    (
                      chave = s_key-chave
                      aedat = sy-datum
                      aezet = sy-uzeit
                      aenam = sy-uname
                      message = s_key-%param-obs
                    )
                )
            )
        )
        MAPPED mapped
        REPORTED reported
        FAILED failed.

    ENDLOOP.
  ENDMETHOD.

  METHOD pin_change.

*register the log
    READ ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(t_hd).

    LOOP AT keys INTO DATA(s_key1).
      DATA(s_hd) = t_hd[ chave = s_key1-chave ].

*check the last seq
      SELECT SINGLE
            MAX( \_logh-seq )
          FROM zcdsmm_i_xml_hist_hd
          WHERE chave = @s_key1-chave
          INTO @DATA(v_next_seq).

      v_next_seq += 1.

      MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        CREATE BY \_logh
        FIELDS (
              chave seq
              aedat
              aezet
              aenam
              camposap
              statusvalid
              oldvalue
              newvalue
            )
        WITH VALUE #(
            (
              chave = s_key1-chave
              %target =
                VALUE #(
                    (
                      chave = s_key1-chave
                      seq = v_next_seq
                      aedat = sy-datum
                      aezet = sy-uzeit
                      aenam = sy-uname
                      camposap = 'PIN'
                      statusvalid = s_hd-statusvalid
                      oldvalue = s_hd-pin
                      newvalue = s_key1-%param-pin
                    )
                )
            )
        )
        MAPPED mapped
        REPORTED reported
        FAILED failed.

    ENDLOOP.

*...and then change the entity
    MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        UPDATE
        FIELDS ( pin )
        WITH VALUE #(
            FOR s_key IN keys
            (
              chave = s_key-chave
              pin = s_key-%param-pin
            )
        )
        MAPPED mapped
        REPORTED reported
        FAILED failed.

  ENDMETHOD.


  METHOD actreq_change.

*register the log
    READ ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(t_hd).

    LOOP AT keys INTO DATA(s_key1).
      DATA(s_hd) = t_hd[ chave = s_key1-chave ].

*check the last seq
      SELECT SINGLE
            MAX( \_logh-seq )
          FROM zcdsmm_i_xml_hist_hd
          WHERE chave = @s_key1-chave
          INTO @DATA(v_next_seq).

      v_next_seq += 1.

      MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        CREATE BY \_logh
        FIELDS (
              chave seq
              aedat
              aezet
              aenam
              camposap
              statusvalid
              oldvalue
              newvalue
            )
        WITH VALUE #(
            (
              chave = s_key1-chave
              %target =
                VALUE #(
                    (
                      chave = s_key1-chave
                      seq = v_next_seq
                      aedat = sy-datum
                      aezet = sy-uzeit
                      aenam = sy-uname
                      camposap = 'ACTION_REQUIRED'
                      statusvalid = s_hd-statusvalid
                      oldvalue = s_hd-actionrequired
                      newvalue = s_key1-%param-actreq
                    )
                )
            )
        )
        MAPPED mapped
        REPORTED reported
        FAILED failed.

    ENDLOOP.

*...and then change the entity
    MODIFY ENTITIES
        OF zcdsmm_i_xml_hist_hd
        ENTITY xml_hd
        UPDATE
        FIELDS ( actionrequired )
        WITH VALUE #(
            FOR s_key IN keys
            (
              chave = s_key-chave
              actionrequired = s_key-%param-actreq
            )
        )
        MAPPED mapped
        REPORTED reported
        FAILED failed.

  ENDMETHOD.

  METHOD nfwrite.

***
* the user can command a Nf Write process from the front-end. The writing is
* done by another service. Here we receive the generated Docnum
***

    LOOP AT keys INTO DATA(s_key). "should be only one by the way

*set it on the entity
      MODIFY ENTITIES
          OF zcdsmm_i_xml_hist_hd
          ENTITY xml_hd
          UPDATE
          FIELDS ( nfwritedocnum )
          WITH VALUE #(
              (
                chave = s_key-Chave
                nfwritedocnum = s_key-%param-docnum
              )
          )
          MAPPED mapped
          REPORTED reported
          FAILED failed.

    ENDLOOP. "keys

  ENDMETHOD.

ENDCLASS.
