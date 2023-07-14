///scr_ease_inout_circ(time, start, change, duration)

/**
 * Returns the easing function result
 *
 * @param   time      Time current position, real
 * @param   start     Start time position, real
 * @param   change    Change current amount, real
 * @param   duration  Total duration, real
 * 
 * @return  Returns the easing function result, real
 *
 * @license http://robertpenner.com/easing_terms_of_use.html
 */

var _t = argument[0];
var _b = argument[1];
var _c = argument[2];
var _d = argument[3];

var _td2 = _t/(_d/2);

if ((_td2) < 1) {
    return -_c/2 * (sqrt(1 - _td2*_td2) - 1) + _b;
}

return _c/2 * (sqrt(1 - (_td2-2)*(_td2-2)) + 1) + _b;
