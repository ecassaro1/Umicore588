*&---------------------------------------------------------------------*
*& Report zmm_edoc_br_delete
*&---------------------------------------------------------------------*
*& Deleção de objetos do eDoc e do 70000588
*&---------------------------------------------------------------------*

REPORT zmm_edoc_br_delete.


TABLES:
  edobrincoming.

PARAMETERS:
    p_ak TYPE edobrincoming-accesskey OBLIGATORY.


end-of-selection.
  PERFORM f_del.


FORM f_del.
  SELECT SINGLE
        edoc_guid
    FROM edobrincoming
    WHERE accesskey = @p_ak
    INTO @DATA(v_edoc_guid).

  CHECK ( NOT v_edoc_guid IS INITIAL ).

  SELECT
        bukrs
    FROM edocument
    WHERE   edoc_guid = @v_edoc_guid
    INTO @DATA(v_bukrs)
    UP TO 1 ROWS.
  ENDSELECT.

  DELETE FROM:
      edobrincoming
          WHERE   accesskey = p_ak,
      edocumentfile
          WHERE   edoc_guid = v_edoc_guid,
      edocument
          WHERE   edoc_guid = v_edoc_guid,
      edocumenthistory
          WHERE   edoc_guid = v_edoc_guid.

  IF ( v_bukrs = 'BR05' ). "COIMPA
    DELETE FROM:
        ztmm_xml_hist_hd
            WHERE chave = p_ak,
        ztmm_xml_hist_it
            WHERE chave = p_ak,
        ztmm_log_erros
            WHERE chave = p_ak,
        ztmm_xml_hd_cod
            WHERE chave = p_ak,
        ztmm_xml_log
            WHERE chave = p_ak,
        ztmm_xml_obsh
            WHERE chave = p_ak,
        ztmm_xml_obs
            WHERE chave = p_ak.
  ENDIF.

  MESSAGE s000(z_mm) WITH 'XML deletado com sucesso'.
ENDFORM.
