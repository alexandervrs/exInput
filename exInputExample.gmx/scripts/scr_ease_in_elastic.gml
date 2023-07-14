///scr_ease_in_elastic(time, start, change, duration)

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
 
var _td = _t/_d;

var _s = 1.70158;
var _p = 0;
var _a = _c;

if (_t == 0) {
    return _b;
}
if ((_td) == 1) { 
    return _b+_c;
}
if (!_p) {
    _p = _d*0.3;
}
if (_a < abs(_c)) {
    _a = _c;
    _s = _p/4;
} else {
    _s = _p/(2*pi) * arcsin (_c/_a);
}

return -(_a*power(2, 10*(_td-1)) * sin( ((_td-1)*_d-_s)*(2*pi)/_p )) + _b;
