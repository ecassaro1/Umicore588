CLASS lhc_zcdsmm_i_xml_r_cfop DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validatefields FOR VALIDATE ON SAVE IMPORTING keys FOR xml_r_cfop~validatefields.

ENDCLASS.

CLASS lhc_zcdsmm_i_xml_r_cfop IMPLEMENTATION.

  METHOD validatefields.

    READ ENTITIES OF zcdsmm_i_xml_r_cfop IN LOCAL MODE
      ENTITY xml_r_cfop FIELDS ( cfop utilmaterial codiva )
      WITH CORRESPONDING #( keys )
      RESULT DATA(results).

    LOOP AT results ASSIGNING FIELD-SYMBOL(<lfs_result>).

      IF <lfs_result>-cfop = space.
        APPEND VALUE #( %key = <lfs_result>-%key ) TO failed-xml_r_cfop.
        APPEND VALUE #( %key = <lfs_result>-%key
                        %msg = new_message( id       = 'ZMM_VALIDATIONS_NF'
                                            number   = 000
                                            v1       = <lfs_result>-cfop
                                            severity = if_abap_behv_message=>severity-error )
                         %element-cfop = if_abap_behv=>mk-on ) TO reported-xml_r_cfop.

      ENDIF.

*      IF <lfs_result>-icmsdesonerado = space.
*        APPEND VALUE #( %key = <lfs_result>-%key ) TO failed-xml_r_cfop.
*        APPEND VALUE #( %key = <lfs_result>-%key
*                        %msg = new_message( id       = 'ZMM_VALIDATIONS_NF'
*                                            number   = 000
*                                            v1       = <lfs_result>-icmsdesonerado
*                                            severity = if_abap_behv_message=>severity-error )
*                         %element-icmsdesonerado = if_abap_behv=>mk-on ) TO reported-xml_r_cfop.
*
*      ENDIF.

*      IF <lfs_result>-origmaterial = space.
*        APPEND VALUE #( %key = <lfs_result>-%key ) TO failed-xml_r_cfop.
*        APPEND VALUE #( %key = <lfs_result>-%key
*                        %msg = new_message( id       = 'ZMM_VALIDATIONS_NF'
*                                            number   = 000
*                                            v1       = <lfs_result>-origmaterial
*                                            severity = if_abap_behv_message=>severity-error )
*                         %element-origmaterial = if_abap_behv=>mk-on ) TO reported-xml_r_cfop.
*
*      ENDIF.

      IF <lfs_result>-utilmaterial = space.
        APPEND VALUE #( %key = <lfs_result>-%key ) TO failed-xml_r_cfop.
        APPEND VALUE #( %key = <lfs_result>-%key
                        %msg = new_message( id       = 'ZMM_VALIDATIONS_NF'
                                            number   = 000
                                            v1       = <lfs_result>-utilmaterial
                                            severity = if_abap_behv_message=>severity-error )
                         %element-utilmaterial = if_abap_behv=>mk-on ) TO reported-xml_r_cfop.

      ENDIF.

      IF <lfs_result>-codiva = space.
        APPEND VALUE #( %key = <lfs_result>-%key ) TO failed-xml_r_cfop.
        APPEND VALUE #( %key = <lfs_result>-%key
                        %msg = new_message( id       = 'ZMM_VALIDATIONS_NF'
                                            number   = 000
                                            v1       = <lfs_result>-codiva
                                            severity = if_abap_behv_message=>severity-error )
                         %element-codiva = if_abap_behv=>mk-on ) TO reported-xml_r_cfop.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
