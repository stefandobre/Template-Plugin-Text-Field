prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_180200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2018.05.24'
,p_release=>'18.2.0.00.12'
,p_default_workspace_id=>13095209289114691
,p_default_application_id=>160
,p_default_owner=>'FX_WS_001'
);
end;
/
prompt --application/shared_components/plugins/item_type/template_text_field
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(1270943565190799950)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'TEMPLATE_TEXT_FIELD'
,p_display_name=>'Template Text Field'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'procedure render',
'    ( p_item   in            apex_plugin.t_item',
'    , p_plugin in            apex_plugin.t_plugin',
'    , p_param  in            apex_plugin.t_item_render_param',
'    , p_result in out nocopy apex_plugin.t_item_render_result',
'    )',
'as    ',
'    l_escaped_value varchar2(32767) := apex_escape.html(p_param.value);',
'    l_name          apex_plugin.t_input_name;',
'    l_display_value varchar2(32767);',
'    ',
'    l_enter_submit  boolean := (coalesce(p_item.attribute_01, ''N'') = ''Y'');',
'    l_is_disabled   boolean := (coalesce(p_item.attribute_02, ''N'') = ''Y'');',
'    l_save_state    boolean := (coalesce(p_item.attribute_03, ''N'') = ''Y'');',
'begin',
'    if p_param.value_set_by_controller and p_param.is_readonly then',
'        return;',
'    end if;',
'',
'    if (p_param.is_readonly or p_param.is_printer_friendly) then',
'        if not (l_is_disabled and not l_save_state) then',
'            apex_plugin_util.print_hidden_if_readonly',
'                ( p_item  => p_item',
'                , p_param => p_param',
'                );',
'        end if;',
'        ',
'        l_display_value := l_escaped_value;',
'        ',
'        apex_plugin_util.print_display_only',
'            ( p_item_name        => p_item.name',
'            , p_display_value    => l_display_value',
'            , p_show_line_breaks => false',
'            , p_escape           => false',
'            , p_attributes       => p_item.element_attributes',
'            );',
'    else',
'    ',
'        if not l_is_disabled or (l_is_disabled and l_save_state)',
'        then',
'            l_name := apex_plugin.get_input_name_for_item;',
'        end if;',
'   ',
'        sys.htp.prn(',
'            ''<input type="text" '' ||',
'            apex_plugin_util.get_element_attributes( p_item',
'                                                   , l_name',
'                                                   , ''text_field apex-item-text'' || case when l_is_disabled then '' apex_disabled'' end',
'                                                   ) ||',
'            ''value="''||l_escaped_value||''" ''||',
'            ''size="''||p_item.element_width||''" ''||',
'            ''maxlength="''||p_item.element_max_length||''" ''||',
'            ',
'            case when l_enter_submit and not l_is_disabled then ',
'                ''onkeypress="return apex.submit({request:'''''' || p_item.name || '''''',submitIfEnter:event})" '' ',
'            end ||',
'',
'            case when l_is_disabled then ',
'                case when l_save_state then ',
'                    ''readonly="readonly" '' ',
'                else ',
'                    ''disabled="disabled" '' ',
'                end ',
'            end ||',
'',
'            '' />'');',
'',
'            if p_item.icon_css_classes is not null then',
'                sys.htp.prn(''<span class="apex-item-icon fa ''|| apex_escape.html_attribute(p_item.icon_css_classes) ||''" aria-hidden="true"></span>'');',
'            end if;',
'',
'        if l_is_disabled and l_save_state and not p_param.value_set_by_controller then',
'            wwv_flow_plugin_util.print_protected',
'                ( p_item_name => p_item.name',
'                , p_value     => p_param.value',
'                );',
'        end if;',
'',
'        p_result.is_navigable := not l_is_disabled;',
'',
'    end if;',
'',
'end render;',
'',
'procedure validate',
'    ( p_item   in            apex_plugin.t_item',
'    , p_param  in            apex_plugin.t_item_validation_param',
'    , p_result in out nocopy apex_plugin.t_item_validation_result',
'    )',
'is',
'    c_trim_spaces      constant varchar2(100) := nvl(p_item.attribute_05, ''BOTH'');',
'    c_restricted_chars constant varchar2(4)   := chr(32) || chr(10) || chr(13) || chr(9);',
'    ',
'    l_value varchar2( 32767 );',
'begin',
'',
'    if c_trim_spaces <> ''NONE'' then',
'        l_value := case c_trim_spaces',
'                     when ''LEADING''  then ltrim(p_param.value, c_restricted_chars)',
'                     when ''TRAILING'' then rtrim(p_param.value, c_restricted_chars)',
'                     when ''BOTH''     then ltrim(rtrim(p_param.value, c_restricted_chars), c_restricted_chars)',
'                   end;',
'        ',
'        if l_value <> p_param.value or (l_value is null and p_param.value is not null) then',
'            apex_util.set_session_state',
'                ( p_name  => p_item.session_state_name',
'                , p_value => l_value',
'                );',
'        end if;',
'    end if;',
'',
'end validate;'))
,p_api_version=>2
,p_render_function=>'render'
,p_validation_function=>'validate'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:QUICKPICK:SOURCE:ELEMENT:WIDTH:PLACEHOLDER:ICON:ENCRYPT:FILTER:LINK'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_is_quick_pick=>true
,p_help_text=>'Displays a text field.'
,p_version_identifier=>'1.0'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1270943755278806601)
,p_plugin_id=>wwv_flow_api.id(1270943565190799950)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>20
,p_prompt=>'Submit when Enter pressed'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_is_common=>false
,p_default_value=>'N'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_help_text=>'Specify whether pressing the <em>Enter</em> key while in this field automatically submits the page.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1270944247444813790)
,p_plugin_id=>wwv_flow_api.id(1270943565190799950)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>30
,p_prompt=>'Disabled'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_is_common=>false
,p_default_value=>'N'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Specify whether this item is disabled, which prevents end users from changing the value.</p>',
'<p>A disabled text item still displays with the same HTML formatting, unlike an item type of <em>Display Only</em>, which removes the HTML formatting. Disabled text items are part of page source, which enables their session state to be evaluated. Con'
||'versely, display only items are not stored in session state.</p>'))
,p_attribute_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$$ DJP  - Is this equivalent to specifying Read Only = Always?',
'If so do we need this attribute?'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1270944744458822364)
,p_plugin_id=>wwv_flow_api.id(1270943565190799950)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>40
,p_prompt=>'Save Session State'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_is_common=>false
,p_default_value=>'N'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(1270944247444813790)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Specify whether the current item value is stored in session state when the page is submitted.'
,p_attribute_comment=>'$$$ DJP - Why can this only be set when Disabled = Y?'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(402227637503398551)
,p_plugin_id=>wwv_flow_api.id(1270943565190799950)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>15
,p_prompt=>'Trim Spaces'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_is_common=>false
,p_default_value=>'BOTH'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Select how the item value is trimmed after submitting the page. This setting trims spaces, tabs, and new lines from the text entered.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(402227933405400450)
,p_plugin_attribute_id=>wwv_flow_api.id(402227637503398551)
,p_display_sequence=>10
,p_display_value=>'Leading'
,p_return_value=>'LEADING'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(402228331249401424)
,p_plugin_attribute_id=>wwv_flow_api.id(402227637503398551)
,p_display_sequence=>20
,p_display_value=>'Trailing'
,p_return_value=>'TRAILING'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(402228729308402312)
,p_plugin_attribute_id=>wwv_flow_api.id(402227637503398551)
,p_display_sequence=>30
,p_display_value=>'Leading and Trailing'
,p_return_value=>'BOTH'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(402229451724407090)
,p_plugin_attribute_id=>wwv_flow_api.id(402227637503398551)
,p_display_sequence=>40
,p_display_value=>'None'
,p_return_value=>'NONE'
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
