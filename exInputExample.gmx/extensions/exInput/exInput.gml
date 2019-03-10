#define ex_input_ds_grid_delete_y
///ex_input_ds_grid_delete_y(DSGridIndex, y, shift)

/*
 * Removes a row at Y position from a DS grid
 *
 * @param   DSGridIndex  The DS grid index, real
 * @param   y            The Y position on the DS grid, real
 * @param   shift        (optional) Whether to shift the rest of the grid, boolean
 * 
 * @return  Returns 1 on success, 0 if reached and removed first item, real
 */

var _grid   = argument[0];
var _y      = argument[1];
var _shift  = false;

if (argument_count >= 3) {
    _shift = argument[2];
}

var _grid_width  = ds_grid_width(_grid);
var _grid_height = ds_grid_height(_grid);

if (_grid_height < 2) {

    ds_grid_clear(_grid, "");
    ds_grid_resize(_grid, ds_grid_width(_grid), 1);

    return 0;
}

// shift is used when you need to get the updated item indexes in a loop usually
if (_shift == true) {

    ds_grid_set_grid_region(_grid, _grid, 0, _y+1, _grid_width-1, _y+1, 0, _y);
    for (var _i=_y; _i <= ds_grid_height(_grid); ++_i) {
        ds_grid_set_grid_region(_grid, _grid, 0, _i+1, _grid_width-1, _i+1, 0, _i);    
    }
    
} else {
    
    ds_grid_set_grid_region(_grid, _grid, 0, _y+1, _grid_width-1, _grid_height-_y, 0, _y);
    
}

ds_grid_resize(_grid, _grid_width, _grid_height-1);

return 1;


#define ex_input_file_decrypt
///ex_input_file_decrypt(fileName, key)

/**
 * Decrypts a file with the given key using buffers
 *
 * @param   fileName  The input filename, string
 * @param   key       A key to decrypt the file with, string
 * 
 * @return  Returns true on success, false if the file cannot be accessed, boolean
 */

var _file, _buffer, _byte, _key_string, _key_char, _string_position;

_file = argument[0];

if (!file_exists(_file)) {
    return false;
}

_buffer = buffer_load(_file);

if (!buffer_exists(_buffer)) {
    return false;
}

_key_string = argument[1];
_string_position = 1;

while (buffer_tell(_buffer) < buffer_get_size(_buffer)) {
     
    if (_string_position <= string_length(_key_string) - 1) {
        _string_position += 1;
    } else {
        _string_position = 1;
    }

    _key_char = ord( string_char_at(_key_string, _string_position));
     
    var _byte = buffer_read(_buffer, buffer_u8);
    
    buffer_seek(_buffer, buffer_seek_relative, -buffer_sizeof(buffer_u8));
    
    _byte -= _key_char;
    if (_byte < 0) {
        _byte += 256;
    }
    
    buffer_write(_buffer, buffer_u8, _byte);
}

// write the file
buffer_save_ext(_buffer, _file, 0, buffer_tell(_buffer));

// cleanup
buffer_delete(_buffer);

return true;

#define ex_input_file_encrypt
///ex_input_file_encrypt(fileName, key)

/**
 * Encrypts a file with the given key using buffers
 *
 * @param   fileName  The input filename, string
 * @param   key       A key to encrypt the file with, string
 * 
 * @return  Returns true on success, false if the file cannot be accessed, boolean
 */

var _file, _buffer, _byte, _key_string, _key_char, _string_position;

_file = argument[0];

if (!file_exists(_file)) {
    return false;
}

_buffer = buffer_load(_file);

if (!buffer_exists(_buffer)) {
    return false;
}

_key_string = argument[1];
_string_position = 1;

while (buffer_tell(_buffer) < buffer_get_size(_buffer)) {
     
    if (_string_position <= string_length(_key_string) - 1) {
        _string_position += 1;
    } else {
        _string_position = 1;
    }

    _key_char = ord( string_char_at(_key_string, _string_position));
     
     var _byte = buffer_read(_buffer, buffer_u8);
     buffer_seek(_buffer, buffer_seek_relative, -buffer_sizeof(buffer_u8));
     buffer_write(_buffer, buffer_u8, (_byte + _key_char) % 256);
}

// write the file
buffer_save_ext(_buffer, _file, 0, buffer_tell(_buffer));

// cleanup
buffer_delete(_buffer);

return true;

#define ex_input_check
///ex_input_check(name, gamepadDevice)

var _handle = argument[0];
var _list = obj_ex_input._ex_input_data;

// check name column
var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), _handle);
if (_y < 0) {
    return -1;
}

// keyboard    
var _keycode = _list[# 1, _y];
// gamepad 
var _gbutton = _list[# 2, _y];
var _gdevice = 0;

if (obj_ex_input._ex_input_mode == ex_input_mode_keyboard and _keycode != ex_input_undefined) {
    
    if (_keycode < 0) {
        return -1;
    }

    if (keyboard_check(_keycode)) {
        return 1;
    } else {
        return 0;
    }
    
} else if (obj_ex_input._ex_input_mode == ex_input_mode_gamepad and _gbutton != ex_input_undefined) {
    
    if (argument_count >= 2) {
        _gdevice = argument[1];
    }

    if (_gbutton < 0) {
        return -1;
    }

    if (gamepad_button_check(_gdevice, _gbutton)) {
        return 1;
    } else {
        return 0;
    }  
      
} else if (obj_ex_input._ex_input_touch_enabled == true and obj_ex_input._ex_input_mode == ex_input_mode_touch) {
    
    if (_gbutton < 0) {
        return -1;
    }
    
    var _joystick = obj_ex_input_joystick;
    
    if (not instance_exists(_joystick)) {
        return -1;
    }
    
    var _keycode_left  = _joystick._keycode_left;
    var _keycode_right = _joystick._keycode_right;
    var _keycode_up    = _joystick._keycode_up;
    var _keycode_down  = _joystick._keycode_down;
    
    if (_keycode == _keycode_left) {

        if (ex_input_virtual_joystick_get_direction(_joystick) == 1) {
            return true;
        } else {
            return false;
        }
    }
    
    if (_keycode == _keycode_right) {

        if (ex_input_virtual_joystick_get_direction(_joystick) == 2) {
            return true;
        } else {
            return false;
        }
    }
    
    if (_keycode == _keycode_down) {

        if (ex_input_virtual_joystick_get_direction(_joystick) == 4) {
            return true;
        } else {
            return false;
        }
    }

    if (_keycode == _keycode_up) {

        if (ex_input_virtual_joystick_get_direction(_joystick) == 3) {
            return true;
        } else {
            return false;
        }
    }

} else {
    return false;
}

#define ex_input_check_any
///ex_input_check_any(gamepadDevice)

if (obj_ex_input._ex_input_mode == ex_input_mode_keyboard) {
    
    // keyboard
    if (keyboard_check(vk_anykey)) {
        return 1;
    } else {
        return 0;
    }
    
} else if (obj_ex_input._ex_input_mode == ex_input_mode_gamepad) {
    
    // gamepad
    var _gdevice = 0;
    
    if (argument_count >= 1) {
        _gdevice = argument[0];
    }
    
    if (gamepad_is_connected(_gdevice)) {
    
        var _gp_any = 0;
    
        var _gp_buttons = gamepad_button_count(_gdevice);
        for (var _i=0; _i <= _gp_buttons; ++_i) {
            if (gamepad_button_check(_gdevice, _i)) {
                _gp_any += 1;
            }
        }
        
        if (_gp_any > 0) {
            return true;
        } else {
            return false;
        }
        
    }
          
} else if (obj_ex_input._ex_input_touch_enabled == true and obj_ex_input._ex_input_mode == ex_input_mode_touch) {
    
    // joystick
    var _joystick = obj_ex_input_joystick;
    
    if (not instance_exists(_joystick)) {
        return -1;
    }
    
    if (
    (ex_input_virtual_joystick_get_direction(_joystick) == 1) or 
    (ex_input_virtual_joystick_get_direction(_joystick) == 2) or 
    (ex_input_virtual_joystick_get_direction(_joystick) == 3) or 
    (ex_input_virtual_joystick_get_direction(_joystick) == 4) 
    ) {
        return true;
    } else {
        return false;
    }
}
    

#define ex_input_check_pressed
///ex_input_check_pressed(name, gamepadDevice)

var _handle = argument[0];
var _list = obj_ex_input._ex_input_data;

// check name column
var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), _handle);
if (_y < 0) {
    return -1;
}

// keyboard    
var _keycode = _list[# 1, _y];
// gamepad 
var _gbutton = _list[# 2, _y];
var _gdevice = 0;

if (obj_ex_input._ex_input_mode == ex_input_mode_keyboard and _keycode != ex_input_undefined) {

    // keyboard    
    var _keycode = _list[# 1, _y];
    
    if (_keycode < 0) {
        return -1;
    }

    if (keyboard_check_pressed(_keycode)) {
        return 1;
    } else {
        return 0;
    }
    
} else if (obj_ex_input._ex_input_mode == ex_input_mode_gamepad and _gbutton != ex_input_undefined) {
    
    if (argument_count >= 2) {
        _gdevice = argument[1];
    }

    if (_gbutton < 0) {
        return -1;
    }

    if (gamepad_button_check_pressed(_gdevice, _gbutton)) {
        return 1;
    } else {
        return 0;
    }  
      
} else if (obj_ex_input._ex_input_touch_enabled == true and obj_ex_input._ex_input_mode == ex_input_mode_touch) {
    
    if (_keycode < 0) {
        return -1;
    }

    if (keyboard_check_pressed(_keycode)) {
        return 1;
    } else {
        return 0;
    }
    
    // joystick
    //var _keycode = _list[# 1, _y];
    
    if (_keycode < 0) {
        return -1;
    }
    
    var _joystick = obj_ex_input_joystick;
    
    if (not instance_exists(_joystick)) {
        return -1;
    }
    
    var _keycode_left  = _joystick._keycode_left;
    var _keycode_right = _joystick._keycode_right;
    var _keycode_up    = _joystick._keycode_up;
    var _keycode_down  = _joystick._keycode_down;
    
    if (_keycode == _keycode_left) {

        if (ex_input_virtual_joystick_get_direction(_joystick) == 1) {
            return true;
        } else {
            return false;
        }
    }
    
    if (_keycode == _keycode_right) {

        if (ex_input_virtual_joystick_get_direction(_joystick) == 2) {
            return true;
        } else {
            return false;
        }
    }
    
    if (_keycode == _keycode_down) {

        if (ex_input_virtual_joystick_get_direction(_joystick) == 4) {
            return true;
        } else {
            return false;
        }
    }

    if (_keycode == _keycode_up) {

        if (ex_input_virtual_joystick_get_direction(_joystick) == 3) {
            return true;
        } else {
            return false;
        }
    }

} else {
    return false;
}

#define ex_input_check_released
///ex_input_check_released(name, gamepadDevice)

var _handle = argument[0];
var _list = obj_ex_input._ex_input_data;

// check name column
var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), _handle);
if (_y < 0) {
    return -1;
}

// keyboard    
var _keycode = _list[# 1, _y];
// gamepad 
var _gbutton = _list[# 2, _y];
var _gdevice = 0;

if (obj_ex_input._ex_input_mode == ex_input_mode_keyboard and _keycode != ex_input_undefined) {
    
    if (_keycode < 0) {
        return -1;
    }

    if (keyboard_check_released(_keycode)) {
        return 1;
    } else {
        return 0;
    }
    
} else if (obj_ex_input._ex_input_mode == ex_input_mode_gamepad and _gbutton != ex_input_undefined) {

    if (argument_count >= 2) {
        _gdevice = argument[1];
    }

    if (_gbutton < 0) {
        return -1;
    }

    if (gamepad_button_check_released(_gdevice, _gbutton)) {
        return 1;
    } else {
        return 0;
    }  
      
} else if (obj_ex_input._ex_input_touch_enabled == true and obj_ex_input._ex_input_mode == ex_input_mode_touch) {
    
    // joystick
    //var _keycode = _list[# 1, _y];
    
    if (_keycode < 0) {
        return -1;
    }
    
    var _joystick = obj_ex_input_joystick;
    
    if (not instance_exists(_joystick)) {
        return -1;
    }
    
    var _keycode_left  = _joystick._keycode_left;
    var _keycode_right = _joystick._keycode_right;
    var _keycode_up    = _joystick._keycode_up;
    var _keycode_down  = _joystick._keycode_down;
    
    if (_keycode == _keycode_left) {

        if (ex_input_virtual_joystick_get_direction(_joystick) != 1) {
            return true;
        } else {
            return false;
        }
    }
    
    if (_keycode == _keycode_right) {

        if (ex_input_virtual_joystick_get_direction(_joystick) != 2) {
            return true;
        } else {
            return false;
        }
    }
    
    if (_keycode == _keycode_down) {

        if (ex_input_virtual_joystick_get_direction(_joystick) != 4) {
            return true;
        } else {
            return false;
        }
    }

    if (_keycode == _keycode_up) {

        if (ex_input_virtual_joystick_get_direction(_joystick) != 3) {
            return true;
        } else {
            return false;
        }
    }

} else {
    return false;
}

#define ex_input_clear
///ex_input_clear()

/**
 * Clears all input states
 * 
 * @return  Returns 1, real
 */

io_clear();

return 1;

#define ex_input_config_load
///ex_input_config_load(filename, password)

var _filename = argument[0];
var _password = "";

if (ex_input_get_debug_mode()) {
    show_debug_message("exInput: Loading config...");
}

if (not file_exists(_filename)) {
    if (ex_input_get_debug_mode()) {
        show_debug_message("exInput: Error, cannot find config file");
    }
    return 0;
}

if (argument_count >= 2) {
    _password = argument[1];
}

if (_password != "") {
    if (ex_input_get_debug_mode()) {
        show_debug_message("exInput: Decoding config using key...");
    }
    ex_input_file_decrypt(_filename, _password);
}

var _buffer = buffer_load(_filename);
_json_string = buffer_read(_buffer, buffer_string);
buffer_delete(_buffer);

var _json = json_decode(_json_string);

if (_json == -1) {

    if (ex_input_get_debug_mode()) {
        show_debug_message("exInput: Error while reading config, invalid JSON or wrong decryption key");
    }
    return 0;
}

if (ex_input_get_debug_mode()) {
    show_debug_message("exInput: Reading config...");
}

if (!ds_map_exists(_json, "input")) {

	if (ex_input_get_debug_mode()) {
        show_debug_message("exInput: Error while reading config, invalid file format");
    }
	return 0;
}

var _input = ds_map_find_value(_json,"input");

if (!ds_map_exists(_input, "keyboard") || !ds_map_exists(_input, "gamepad")) {

	if (ex_input_get_debug_mode()) {
        show_debug_message("exInput: Error while reading config, invalid file format");
    }
	return 0;
}

var _keyboard = ds_map_find_value(_input,"keyboard");
var _ksize    = ds_map_size(_keyboard);
var _gamepad  = ds_map_find_value(_input,"gamepad");
var _gsize    = ds_map_size(_gamepad);
var _tsize    = 0;

var _names_array;
var _keycodes_array;
var _gpcodes_array;

// load keyboard keys
if (_ksize) {

    _key = ds_map_find_first(_keyboard);

    for (var _i = 0; _i<_ksize-1; ++_i) {
    
        _val = ds_map_find_value(_keyboard, _key);
        
        if (_val == "") {
            _val = ex_input_undefined;
        }
        
        if (ex_input_get_debug_mode()) {
            show_debug_message("exInput: Keyboard Key -> "+string( _key )+"="+string( _val ));
        }
        
        _names_array[_i] = _key;
        _keycodes_array[_i] = _val;

        _key = ds_map_find_next(_keyboard, _key);
        _tsize += 1;
    }

    _val = ds_map_find_value(_keyboard,_key);
	
	if (_val == "") {
		_val = ex_input_undefined;
	}
	
    if (ex_input_get_debug_mode()) {
        show_debug_message("exInput: Keyboard Key -> "+string( _key )+"="+string( _val ));
    }
    
    _tsize += 1;
    _names_array[_ksize-1] = _key;
    _keycodes_array[_ksize-1] = _val;

}

// load gamepad buttons
if (_gsize) {

    _key = ds_map_find_first(_gamepad);

    for (var _i = 0; _i<_gsize-1; ++_i) {
    
        _val = ds_map_find_value(_gamepad, _key);
        
        if (_val == "") {
            _val = ex_input_undefined;
        }
        
        if (ex_input_get_debug_mode()) {
            show_debug_message("exInput: Gamepad button -> "+string( _key )+"="+string( _val ));
        }

        _gpcodes_array[_i] = _val;

        _key = ds_map_find_next(_gamepad, _key);
    }

    _val = ds_map_find_value(_gamepad,_key);
	
	if (_val == "") {
		_val = ex_input_undefined;
	}
	
    if (ex_input_get_debug_mode()) {
        show_debug_message("exInput: Gamepad button -> "+string( _key )+"="+string( _val ));
    }

    _gpcodes_array[_gsize-1] = _val;

}

ds_map_destroy(_json);

for (var _i=0; _i<_tsize; ++_i) {

    if (ex_input_exists(_names_array[_i])) {
        ex_input_reassign(_names_array[_i], _keycodes_array[_i], _gpcodes_array[_i]);
    } else {
        ex_input_create(_names_array[_i], _keycodes_array[_i], _gpcodes_array[_i]);
    }
    
}

if (_password != "") {
    if (ex_input_get_debug_mode()) {
        show_debug_message("exInput: Re-encoding config using key...");
    }
    ex_input_file_encrypt(_filename, _password);
}

if (ex_input_get_debug_mode()) {
    show_debug_message('exInput: Loaded config from file "'+_filename+'"');
}

return 1;


#define ex_input_config_save
///ex_input_config_save(filename, password)

var _list      = obj_ex_input._ex_input_data;
var _list_size = ds_grid_height(obj_ex_input._ex_input_data);
var _filename  = argument[0];
var _password  = "";

if (ex_input_get_debug_mode()) {
    show_debug_message("exInput: Saving config...");
}

if (_list_size < 2) {
    if (_list[# 0, 0] == "") {
    
        if (ex_input_get_debug_mode()) {
            show_debug_message("exInput: Error, input list is empty, can't save anything to file");
        }
        return 0;
    }
}

var _txt = file_text_open_write(_filename);

var _json_string = '{"input": { "keyboard": {';

// keyboard data
for (var _i=0; _i<_list_size; ++_i) {
    
    var _input_data = _list[# 1, _i];
    if (_input_data == ex_input_undefined) {
        _input_data = '""';
    }
    
    _json_string += '"'+string( _list[# 0, _i] )+'":'; //name
    _json_string += string( _input_data )+",";      //keycode
}

_json_string = ex_input_string_trim_right(_json_string, ",");

_json_string += '},"gamepad": {';

// gamepad data
for (var _i=0; _i<_list_size; ++_i) {
    
    var _input_data = _list[# 2, _i];
    
    if (_input_data == ex_input_undefined) {
        _input_data = '""';
    }
    
    _json_string += '"'+string( _list[# 0, _i] )+'":'; //name
    _json_string += string( _input_data )+",";      //gpad button
}

_json_string = ex_input_string_trim_right(_json_string, ",");

_json_string += '}}}';

if (ex_input_get_debug_mode()) {
    show_debug_message("exInput: Writing config...");
}

file_text_write_string(_txt, _json_string);

file_text_close(_txt);

if (not file_exists(_filename)) {
    if (ex_input_get_debug_mode()) {
        show_debug_message("exInput: Error while writing config");
    }
    return 0;
}

if (argument_count >= 2) {
    _password = argument[1];
}

if (_password != "") {
    if (ex_input_get_debug_mode()) {
        show_debug_message("exInput: Encoding config using key...");
    }
    ex_input_file_encrypt(_filename, _password);
}

if (ex_input_get_debug_mode()) {
    show_debug_message('exInput: Saved config to file "'+_filename+'"');
}

return 1;


#define ex_input_create
///ex_input_create(name, keyboardKey, gamepadButton)

var _list = obj_ex_input._ex_input_data;
var _list_max_size = 4;
var _autoincrement;
var _name = argument[0];
var _key  = argument[1];
var _gpad = argument[2];
var _icons = -1;

if (_name == "") {
    if (ex_input_get_debug_mode()) {
        show_debug_message('exInput: Error, input name cannot be empty');
    }
    return -1;
}

if (ds_exists(_list, ds_type_grid)) {
    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
    _autoincrement = ds_grid_height(_list)-1;
} else {
    obj_ex_input._ex_input_data = ds_grid_create(_list_max_size, 0);
    _list = obj_ex_input._ex_input_data;
    ds_grid_resize(_list, _list_max_size, ds_grid_height(_list)+1);
    _autoincrement = 0;
}


var _y = ds_grid_value_y(_list, 0, 0, ds_grid_width(_list), ds_grid_height(_list), _name);
if (_y > -1) {
    if (ex_input_get_debug_mode()) {
        show_debug_message('exInput: Error, input name "'+_name+'" already exists');
    }
    return -1;
}

_list[# 0, _autoincrement] = _name;  // name
_list[# 1, _autoincrement] = _key;   // keyboard keycode
_list[# 2, _autoincrement] = _gpad;  // gamepad button
_list[# 3, _autoincrement] = _icons; // icons

if (ex_input_get_debug_mode()) {
    show_debug_message('exInput: Created input "'+_name+'" ('+string(_key)+','+string( _gpad )+')');
}

return _autoincrement;

#define ex_input_destroy
///ex_input_destroy(name)

var _handle = argument[0];
var _list = obj_ex_input._ex_input_data;

// check name column
var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), _handle);
if (_y < 0) {
    return -1;
}

var _map = _list[# 3, _y];

if (ds_exists(_map, ds_type_map)) {
    ds_map_destroy(_map);
}

// remove row
ex_input_ds_grid_delete_y(_list, _y, true);


if (ex_input_get_debug_mode()) {
    show_debug_message('exInput: Destroyed input "'+_handle+'"');
}

return 1;

#define ex_input_device_get_tilt_x
///ex_input_device_get_tilt_x()

gml_pragma("forceinline");

return device_get_tilt_x();

#define ex_input_device_get_tilt_y
///ex_input_device_get_tilt_y()

gml_pragma("forceinline");

return device_get_tilt_y();

#define ex_input_device_get_tilt_z
///ex_input_device_get_tilt_z()

gml_pragma("forceinline");

return device_get_tilt_z();

#define ex_input_exists
///ex_input_exists(name)

var _handle = argument[0];
var _list = obj_ex_input._ex_input_data;

// check name column
var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), _handle);
if (_y < 0) {
    return 0;
} else {
    return 1;
}


#define ex_input_gamepad_set_color
///ex_input_gamepad_set_color(color, gamepadDevice)

gml_pragma("forceinline"); 

// sets the color of the selected gamepad device

if (obj_ex_input._ex_input_mode == ex_input_mode_gamepad) {
        
    var _gdevice = 0;

    if (argument_count >= 2) {
        _gdevice = argument[1];
    }
    
    gamepad_set_color(_gdevice, argument[0]);
    
    return true;

} else {
    return false;
}

#define ex_input_gamepad_vibrate_start
///ex_input_gamepad_vibrate_start(motorLeftForce, motorRightForce, duration, easing, syncDelta, gamepadDevice)

// starts the vibration of the selected gamepad device

gml_pragma("forceinline"); 

if (obj_ex_input._ex_input_vibration == false) {
	return 0;
}

if (obj_ex_input._ex_input_mode != ex_input_mode_gamepad) {
	return 0;
}

var _list = obj_ex_input._ex_input_gamepad_data;
var _device = 0;
var _easing = -1;
var _sync = false;

if (argument_count >= 4) {
    _easing = argument[3];
}

if (argument_count >= 5) {
    _sync = argument[4];
}

if (argument_count >= 6) {
    _device = argument[5];
}

_list[# _ex_input_gamepads._vibration_motor_left,  _device] = argument[0];
_list[# _ex_input_gamepads._vibration_motor_right, _device] = argument[1];
_list[# _ex_input_gamepads._vibration_position,    _device] = -1;
_list[# _ex_input_gamepads._vibration_duration,    _device] = argument[2];
_list[# _ex_input_gamepads._vibration_easing,    _device] = _easing;
_list[# _ex_input_gamepads._vibration_sync,    _device] = _sync;
_list[# _ex_input_gamepads._vibration_motor_left_start, _device]  = argument[0];
_list[# _ex_input_gamepads._vibration_motor_right_start, _device] = argument[1];
_list[# _ex_input_gamepads._vibration_motor_left_end, _device]  = 0.0;
_list[# _ex_input_gamepads._vibration_motor_right_end, _device] = 0.0;

//show_debug_message("vibration started");

return 1;


#define ex_input_gamepad_vibrate_stop
///ex_input_gamepad_vibrate_stop(gamepadDevice)

gml_pragma("forceinline"); 

// stops the vibration of the selected controller device

if (obj_ex_input._ex_input_vibration == true) {

    if (obj_ex_input._ex_input_mode == ex_input_mode_gamepad) {

        var _gdevice = 0;

        if (argument_count >= 1) {
            _gdevice = argument[0];
        }
        
        gamepad_set_vibration(_gdevice, 0, 0);
        
        return true;
    
    } else {
        return false;
    }

} else {
    // vibration is off by settings
    return false;
}

#define ex_input_get_debug_mode
///ex_input_get_debug_mode()

return obj_ex_input._ex_input_debug_mode;

#define ex_input_get_icon
///ex_input_get_icon(name)

var _table = obj_ex_input._ex_input_data;

var _icon;
_icon = -1;

/// arguments
var _index = argument[0];

if (_table < 0) {
    return -1;
}

if (_index < 0 or _index > ds_grid_height(_table)) {
    return -1;
}

// check name column
var _y = ds_grid_value_y(_table, 0, 0, 1, ds_grid_height(_table), _index);
if (_y < 0) {
    return -1;
}

_map = _table[# 3, _y];

switch (os_type) {
    case os_ps3: case os_ps4: case os_psvita: case os_psp: _icon = ds_map_find_value(_map, ex_input_icon_type_gamepad_playstation); break;
    case os_xbox360: case os_xboxone: _icon = ds_map_find_value(_map, ex_input_icon_type_gamepad_xbox); break;
    case os_android:
        if (ex_input_os_is_ouya()) {
            _icon = ds_map_find_value(_map, ex_input_icon_type_gamepad_ouya);
        } else {
            _icon = ds_map_find_value(_map, ex_input_icon_type_gamepad_android);
        }
    break;
    default: 
        if (obj_ex_input._ex_input_mode == ex_input_mode_keyboard or obj_ex_input._ex_input_mode == ex_input_mode_touch) { 
            _icon = ds_map_find_value(_map, ex_input_icon_type_keyboard);
        } else if (obj_ex_input._ex_input_mode == ex_input_mode_gamepad) {
            _icon = ds_map_find_value(_map, ex_input_icon_type_gamepad);
        }
}

return _icon;

#define ex_input_get_mode
///ex_input_get_mode()

return obj_ex_input._ex_input_mode;


#define ex_input_get_touch_enabled
///ex_input_get_touch_enabled()

return obj_ex_input._ex_input_touch_enabled;

#define ex_input_get_vibration_enabled
///ex_input_get_vibration_enabled()

return obj_ex_input._ex_input_vibration;


#define ex_input_initialize
///ex_input_initialize()

if (instance_exists(obj_ex_input)) {

    if (ex_input_get_debug_mode()) {
        show_debug_message('exInput: Warning, Input system is already initialized');
    }

    return 0;
}

// create exInput object
instance_create(0, 0, obj_ex_input);

return 1;

#define ex_input_mouse_click
///ex_input_mouse_click(mouseButton, instanceIndex)

if (obj_ex_input._ex_input_touch_enabled == false) {
    return 0;
}

var _button   = mb_left;
var _instance = noone;

if (argument_count >= 1) {
    _button = argument[0];
}

if (argument_count >= 2) {
    _instance = argument[1];   
    
    if (not instance_exists(_instance)) {
        return 0;
    } 
}

if (_instance == noone) {
    return (mouse_check_button_pressed(_button));
} else {

    return (mouse_check_button_pressed(_button) and 
            (mouse_x >= _instance.bbox_left and
            mouse_x <= _instance.bbox_right and
            mouse_y >= _instance.bbox_top and
            mouse_y <= _instance.bbox_bottom));
}

#define ex_input_mouse_get_x
///ex_input_mouse_get_x()

gml_pragma("forceinline");

return mouse_x;

#define ex_input_mouse_get_y
///ex_input_mouse_get_y()

gml_pragma("forceinline");

return mouse_y;

#define ex_input_mouse_hide
///ex_input_mouse_hide()

gml_pragma("forceinline"); 

return window_set_cursor(cr_none);

#define ex_input_mouse_over
///ex_input_mouse_over(instanceIndex)

var _instance = argument[0];

if (not instance_exists(_instance)) {
    return 0;
}

return (mouse_x >= _instance.bbox_left and
        mouse_x <= _instance.bbox_right and
        mouse_y >= _instance.bbox_top and
        mouse_y <= _instance.bbox_bottom);

#define ex_input_mouse_release
///ex_input_mouse_release(mouseButton, instanceIndex)

var _instance = noone;
var _button   = mb_left;

if (not instance_exists(_instance)) {
    return 0;
}

if (argument_count >= 1) {
    _button = argument[0];
}

if (argument_count >= 2) {
    _instance  = argument[1];
    
    if (not instance_exists(_instance)) {
        return 0;
    }
}

if (_instance == noone) {

        return (mouse_check_button_released(_button));
          
    } else {

        return (mouse_check_button_released(_button) and 
            (mouse_x >= _instance.bbox_left and
            mouse_x <= _instance.bbox_right and
            mouse_y >= _instance.bbox_top and
            mouse_y <= _instance.bbox_bottom));

}

#define ex_input_mouse_show
///ex_input_mouse_show()

gml_pragma("forceinline"); 

return window_set_cursor(cr_default);

#define ex_input_mouse_wheel
///ex_input_mouse_wheel(wheelDirection, instanceIndex)

if (obj_ex_input._ex_input_touch_enabled == false) {
    return 0;
}

var _instance  = noone;
var _direction = argument[0];

if (argument_count >= 2) {
    _instance  = argument[1];
    
    if (not instance_exists(_instance)) {
        return 0;
    }
}

if (_direction == ex_input_mouse_wheel_down) {

    if (_instance == noone) {
        return (mouse_wheel_down());
    } else {

        return (mouse_wheel_down() and 
                (mouse_x >= _instance.bbox_left and
                mouse_x <= _instance.bbox_right and
                mouse_y >= _instance.bbox_top and
                mouse_y <= _instance.bbox_bottom)
        );
        
    }

} else if (_direction == ex_input_mouse_wheel_up) {

    if (_instance == noone) {
        return (mouse_wheel_up());
    } else {
        return (mouse_wheel_up() and 
                (mouse_x >= _instance.bbox_left and
                mouse_x <= _instance.bbox_right and
                mouse_y >= _instance.bbox_top and
                mouse_y <= _instance.bbox_bottom)
        );    
    }

}

return 0;

#define ex_input_reassign
///ex_input_reassign(name, keyboardKey, gamepadButton)

var _handle = argument[0];
var _list = obj_ex_input._ex_input_data;

var _key  = ex_input_undefined;
var _gpad = ex_input_undefined;

if (argument_count >= 2) {
    _key = argument[1];
}

if (argument_count >= 3) {
    _gpad = argument[2];
}

// check name column
var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), _handle);
if (_y < 0) {
    return -1;
}

_list[# 1, _y] = _key;
_list[# 2, _y] = _gpad;

if (ex_input_get_debug_mode()) {
    show_debug_message("exInput: Reassigned input "+string(_handle)+" to keyboard key: "+string(argument[1])+", gamepad button: "+string(argument[2]));
}

return 1;

#define ex_input_set_debug_mode
///ex_input_set_debug_mode(enabled)

obj_ex_input._ex_input_debug_mode = argument[0];


#define ex_input_set_icons
///ex_input_set_icons(name, keyboardIcon, gamepadIcon, playstationIcon, xboxIcon, ouyaIcon, androidIcon)

var _table = obj_ex_input._ex_input_data;

/// arguments
var _index = argument[0];

if (_table < 0) {
    return -1;
}

// check name column
var _y = ds_grid_value_y(_table, 0, 0, 1, ds_grid_height(_table), _index);
if (_y < 0) {
    return -1;
}

var _psicon   = argument[2];
var _xboxicon = argument[2];
var _ouyaicon = argument[2];
var _androidicon = argument[2];

if (argument_count >= 4) {
    _psicon = argument[3];
}
if (argument_count >= 5) {
    _xboxicon = argument[4];
}
if (argument_count >= 6) {
    _ouyaicon = argument[5];
}
if (argument_count >= 7) {
    _androidicon = argument[6];
}

var _map = ds_map_create();
ds_map_add(_map, ex_input_icon_type_keyboard,            argument[1]);
ds_map_add(_map, ex_input_icon_type_gamepad,             argument[2]);
ds_map_add(_map, ex_input_icon_type_gamepad_playstation, _psicon);
ds_map_add(_map, ex_input_icon_type_gamepad_xbox,        _xboxicon);
ds_map_add(_map, ex_input_icon_type_gamepad_ouya,        _ouyaicon);
ds_map_add(_map, ex_input_icon_type_gamepad_android,     _androidicon);

_table[# 3, _y] = _map;

return 1;

#define ex_input_set_mode
///ex_input_set_mode(inputMode)

obj_ex_input._ex_input_mode = argument[0];


#define ex_input_set_mode_autodetect
///ex_input_set_mode_autodetect()

gml_pragma("forceinline"); 

if (keyboard_check(vk_anykey) and ex_input_get_mode() != ex_input_mode_keyboard) {
    obj_ex_input._ex_input_mode = ex_input_mode_keyboard;
    if (ex_input_get_debug_mode()) {
        show_debug_message('exInput: Input mode changed to keyboard');
    }
}

if (gamepad_is_connected(0) and ex_input_get_mode() != ex_input_mode_gamepad) {
var _gp_buttons = gamepad_button_count(0);
    for (var _i=0; _i <= _gp_buttons; ++_i) {
        if (gamepad_button_check(0, _i)){
            obj_ex_input._ex_input_mode = ex_input_mode_gamepad;
            if (ex_input_get_debug_mode()) {
                show_debug_message('exInput: Input mode changed to gamepad');
            }
            break;
        }
    }
}

if (obj_ex_input._ex_input_touch_enabled == true and ex_input_get_mode() != ex_input_mode_touch) {
    if (mouse_check_button(mb_any)) {
        obj_ex_input._ex_input_mode = ex_input_mode_touch;
        if (ex_input_get_debug_mode()) {
            show_debug_message('exInput: Input mode changed to touch');
        }
    }
}


#define ex_input_set_touch_enabled
///ex_input_set_touch_enabled(modeEnabled)

obj_ex_input._ex_input_touch_enabled = argument[0];


#define ex_input_set_vibration_enabled
///ex_input_set_vibration_enabled(vibrationEnabled)

obj_ex_input._ex_input_vibration = argument[0];


#define ex_input_virtual_button_create
///ex_input_virtual_button_create(inputName, sprite, x, y)

var _obj = instance_create(0, 0, obj_ex_input_button);

_obj._sprite = argument[1];
_obj._x = argument[2];
_obj._y = argument[3];

var _list = obj_ex_input._ex_input_data;

// check name column
var _yy = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( argument[0] ));
if (_yy < 0) {
    with (_obj) {
        instance_destroy();
    }
    return -1;
}

_obj._keycode = _list[# 1, _yy];
with (_obj) {
    _vkey = virtual_key_add(_x, _y, sprite_get_width(_sprite), sprite_get_height(_sprite), _keycode );
}

return _obj;

#define ex_input_virtual_button_destroy
///ex_input_virtual_button_destroy(buttonHandle)

with (argument[0]) {
    virtual_key_delete(_vkey);
    instance_destroy();
}

#define ex_input_virtual_button_set_alpha
///ex_input_virtual_button_set_alpha(buttonHandle, alpha)

with (argument[0]) {
    _alpha = argument[1];
}

#define ex_input_virtual_joystick_create
///ex_input_virtual_joystick_create(upInputName, downInputName, leftInputName, rightInputName, spriteTop, spriteBottom)

var _obj = instance_create(0, 0, obj_ex_input_joystick);

with (_obj) {

    var _list = obj_ex_input._ex_input_data;
    
    _sprite_top    = argument[4];
    _sprite_bottom = argument[5];
    _width = (sprite_get_width(_sprite_bottom) / 2);
    _height = (sprite_get_height(_sprite_bottom) / 2);
    
    // up
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( argument[0] ));
    if (_y < 0) {
        //instance_destroy();
        return -1;
    }

    _keycode_up = _list[# 1, _y];
    
    // down   
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( argument[1] ));
    if (_y < 0) {
        //instance_destroy();
        return -1;
    }

    _keycode_down = _list[# 1, _y];    
    
    // left   
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( argument[2] ));
    if (_y < 0) {
        //instance_destroy();
        return -1;
    }

    _keycode_left = _list[# 1, _y];    
    
    
    // right  
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( argument[3] ));
    if (_y < 0) {
        //instance_destroy();
        return -1;
    }

    _keycode_right = _list[# 1, _y];   
    
}

if (ex_input_get_debug_mode()) {
    show_debug_message('exInput: Created virtual joystick');
}

return _obj;

#define ex_input_virtual_joystick_destroy
///ex_input_virtual_joystick_destroy(joystickHandle)

with (argument[0]) {
    instance_destroy();
    if (ex_input_get_debug_mode()) {
        show_debug_message('exInput: Destroyed virtual joystick');
    }
}


#define ex_input_virtual_joystick_get_direction
///ex_input_virtual_joystick_get_direction(joystickHandle)

// return virtual joystick's direction by its angle

var _joystick, _joystick_direction;

_joystick = argument[0];
_joystick_direction = -1;

with (_joystick) {

    _joystick_angle = _rel_distance;

    if ((_rel_distance < 45 and _rel_distance >= 0) or _rel_distance > 315) {
        _joystick_direction = 2;
    }
    if (_rel_distance > 135 and _rel_distance < 215) {
        _joystick_direction = 1;
    }
    if (_rel_distance >= 45 and _rel_distance <= 135) {
        _joystick_direction = 3;
    }
    if (_rel_distance >= 215 and _rel_distance < 315) {
        _joystick_direction = 4;
    }

}

return _joystick_direction;

#define ex_input_virtual_joystick_set_alpha
///ex_input_virtual_joystick_set_alpha(joystickHandle, alpha)

with (argument[0]) {
    _alpha = argument[1];
}

#define ex_input_virtual_joystick_set_display_scale
///ex_input_virtual_joystick_set_display_scale(joystickHandle, scale)

with (argument[0]) {

    _display_scale = argument[1];
    return 1;

}

return 0;

#define ex_input_virtual_joystick_set_keycodes
///ex_input_virtual_joystick_set_keycodes(joystickHandle, up, down, left, right)

with (argument[0]) {

    var _list = obj_ex_input._ex_input_data;
    
    // up
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( argument[1] ));
    if (_y < 0) {
        return -1;
    }

    _keycode_up = _list[# 1, _y];
    
    // down   
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( argument[2] ));
    if (_y < 0) {
        return -1;
    }

    _keycode_down = _list[# 1, _y];    
    
    // left   
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( argument[3] ));
    if (_y < 0) {
        return -1;
    }

    _keycode_left = _list[# 1, _y];    
    
    
    // right  
    var _y = ds_grid_value_y(_list, 0, 0, 1, ds_grid_height(_list), string( argument[4] ));
    if (_y < 0) {
        return -1;
    }

    _keycode_right = _list[# 1, _y];
    
}

#define ex_input_virtual_joystick_set_region
///ex_input_virtual_joystick_set_region(joystickHandle, x, y, width, height)

with (argument[0]) {

    _region_x      = argument[1];
    _region_y      = argument[2];
    _region_width  = argument[3];
    _region_height = argument[4];
    return 1;

}

return 0;

#define ex_input_virtual_joystick_set_visibility
///ex_input_virtual_joystick_set_visibility(joystickHandle, visible)

with (argument[0]) {
    _visible = argument[1];
}

#define ex_input_math_smoothstep
///ex_input_math_smoothstep(a, b, t)

/**
 * Returns 0 when (t < upperBound), 1 when (t >= lowerBound)
 * a smooth transition from 0 to 1 otherwise
 * or -1 on error (upperBound == lowerBound)
 *
 * @param   a  Lower bound, real
 * @param   b  Upper bound, real
 * @param   t  Value, real
 * 
 * @return  Returns the smoothstep value (0, 1 or -1 on error), real
 *
 * @license http://gmlscripts.com/license
 */

gml_pragma("forceinline"); 
 
var _p;

var _a = argument[0];
var _b = argument[1];
var _t = argument[2];

if (_t < _a) { 
    return 0;
}

if (_t >= _b) {
    return 1;
}

if (_a == _b) {
    return -1;
}

_p = ((_t - _a) / (_b - _a));

return (_p * _p * (3 - 2 * _p));

#define ex_input_os_is_browser
///ex_input_os_is_browser()

/**
 * Returns whether the game is running through a web browser
 *
 * @return  Returns whether the game is running through a web browser, boolean
 */

gml_pragma("forceinline");
 
if (os_browser == browser_not_a_browser) {
    return false;
} else {
    return true;
}

#define ex_input_os_is_mobile
///ex_input_os_is_mobile()

/**
 * Returns whether the game is running on a mobile device
 *
 * @return  Returns whether the game is running on a mobile device, boolean
 */

if ((os_type == os_android or os_type == os_ios or os_type == os_tizen or os_type == os_winphone) and (not(ex_input_os_is_ouya()))) {
    return true;
} else {
    return false;
}

#define ex_input_os_is_ouya
///ex_input_os_is_ouya()

/**
 * Returns whether the game is running on an Ouya console
 *
 * @return  Returns whether the game is running on an Ouya console, boolean
 */

var _os_map = os_get_info();

if (_os_map != -1) {

    var _device = ds_map_find_value(_os_map, "DEVICE");
    
    ds_map_destroy(_os_map);
    
    if (_device == "cardhu" or _device == "ouya_1_1" or _device == "ouya") {
        return true;
    } else {
        return false;
    }
    
} else {
    return false;
}


#define ex_input_string_trim_right
///ex_input_string_trim_right(string, characterSet)

/**
 * Trims characters from the right of a string
 *
 * @param   string        The input string, string
 * @param   characterSet  (optional) Characters to remove from the side, string
 * 
 * @return  Returns a string with the characters trimmed from its right side, string
 */

var _charlist, _string, _a, _b, _t, _position;

_string = argument[0];
_charlist = " ";

if (argument_count >= 2) {
_charlist = argument[1];
}

while (string_pos("..", _charlist) > 1 and string_length(_charlist) > 2) {

    _position = string_pos("..", _charlist);
    _a = ord(string_char_at(_charlist, _position-1));
    _b = ord(string_char_at(_charlist, _position+2));
    _t = "";
    
    for (var _i=_a; _i<=_b; ++_i) {
        _t += chr(_i);
    }
    _charlist = string_insert(_t, string_delete(_charlist, _position-1, 4), _position-1);
}

while (string_length(_string) > 0) {
    if ( string_pos(string_char_at(_string, string_length(_string)), _charlist) > 0) {
        _string = string_delete(_string, string_length(_string), 1);
    } else {
        break;
    }
}

return _string;


