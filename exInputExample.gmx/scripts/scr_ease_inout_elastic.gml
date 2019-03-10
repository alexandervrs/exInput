///scr_ease_inout_elastic(time, start, change, duration)

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
 
var _s = 1.70158;
var _p = 0;
var _a = _c;

if (_t == 0) {
    return _b;
}
if ((_td2) == 2) {
    return _b+_c;
}
if (!_p) { 
    _p=_d*(0.3*1.5);
}
if (_a < abs(_c)) {
    _a=_c;
    _s= _p/4;
} else {
    _s = _p/(2*pi) * arcsin(_c/_a);
}
if (_td2 < 1) {
    return -0.5*(_a*power(2,10*(_td2-1)) * sin( ((_td2-1)*_d-_s)*(2*pi)/_p )) + _b;
}

return _a*power(2,-10*(_td2-1)) * sin( ((_td2-1)*_d-_s)*(2*pi)/_p )*0.5 + _c + _b;
