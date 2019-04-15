procedure render
    ( p_item   in            apex_plugin.t_item
    , p_plugin in            apex_plugin.t_plugin
    , p_param  in            apex_plugin.t_item_render_param
    , p_result in out nocopy apex_plugin.t_item_render_result
    )
as    
    l_escaped_value varchar2(32767) := apex_escape.html(p_param.value);
    l_name          apex_plugin.t_input_name;
    l_display_value varchar2(32767);
    
    l_enter_submit  boolean := (coalesce(p_item.attribute_01, 'N') = 'Y');
    l_is_disabled   boolean := (coalesce(p_item.attribute_02, 'N') = 'Y');
    l_save_state    boolean := (coalesce(p_item.attribute_03, 'N') = 'Y');
begin
    if p_param.value_set_by_controller and p_param.is_readonly then
        return;
    end if;

    if (p_param.is_readonly or p_param.is_printer_friendly) then
        if not (l_is_disabled and not l_save_state) then
            apex_plugin_util.print_hidden_if_readonly
                ( p_item  => p_item
                , p_param => p_param
                );
        end if;
        
        l_display_value := l_escaped_value;
        
        apex_plugin_util.print_display_only
            ( p_item_name        => p_item.name
            , p_display_value    => l_display_value
            , p_show_line_breaks => false
            , p_escape           => false
            , p_attributes       => p_item.element_attributes
            );
    else
    
        if not l_is_disabled or (l_is_disabled and l_save_state)
        then
            l_name := apex_plugin.get_input_name_for_item;
        end if;
   
        sys.htp.prn(
            '<input type="text" ' ||
            apex_plugin_util.get_element_attributes( p_item
                                                   , l_name
                                                   , 'text_field apex-item-text' || case when l_is_disabled then ' apex_disabled' end
                                                   ) ||
            'value="'||l_escaped_value||'" '||
            'size="'||p_item.element_width||'" '||
            'maxlength="'||p_item.element_max_length||'" '||
            
            case when l_enter_submit and not l_is_disabled then 
                'onkeypress="return apex.submit({request:''' || p_item.name || ''',submitIfEnter:event})" ' 
            end ||

            case when l_is_disabled then 
                case when l_save_state then 
                    'readonly="readonly" ' 
                else 
                    'disabled="disabled" ' 
                end 
            end ||

            ' />');

            if p_item.icon_css_classes is not null then
                sys.htp.prn('<span class="apex-item-icon fa '|| apex_escape.html_attribute(p_item.icon_css_classes) ||'" aria-hidden="true"></span>');
            end if;

        if l_is_disabled and l_save_state and not p_param.value_set_by_controller then
            wwv_flow_plugin_util.print_protected
                ( p_item_name => p_item.name
                , p_value     => p_param.value
                );
        end if;

        p_result.is_navigable := not l_is_disabled;

    end if;

end render;

procedure validate
    ( p_item   in            apex_plugin.t_item
    , p_param  in            apex_plugin.t_item_validation_param
    , p_result in out nocopy apex_plugin.t_item_validation_result
    )
is
    c_trim_spaces      constant varchar2(100) := nvl(p_item.attribute_05, 'BOTH');
    c_restricted_chars constant varchar2(4)   := chr(32) || chr(10) || chr(13) || chr(9);
    
    l_value varchar2( 32767 );
begin

    if c_trim_spaces <> 'NONE' then
        l_value := case c_trim_spaces
                     when 'LEADING'  then ltrim(p_param.value, c_restricted_chars)
                     when 'TRAILING' then rtrim(p_param.value, c_restricted_chars)
                     when 'BOTH'     then ltrim(rtrim(p_param.value, c_restricted_chars), c_restricted_chars)
                   end;
        
        if l_value <> p_param.value or (l_value is null and p_param.value is not null) then
            apex_util.set_session_state
                ( p_name  => p_item.session_state_name
                , p_value => l_value
                );
        end if;
    end if;

end validate;