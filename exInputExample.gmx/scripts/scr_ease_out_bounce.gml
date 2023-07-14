///scr_ease_out_bounce(time, start, change, duration)

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
var _ret;
 
if ((_td) < (1/2.75)) {
    _ret = _c*(7.5625*_td*_td) + _b;
} else if (_td < (2/2.75)) {
    _ret = _c*(7.5625*(_td-(1.5/2.75))*(_td-(1.5/2.75)) + 0.75) + _b;
} else if (_td < (2.5/2.75)) {
    _ret = _c*(7.5625*(_td-(2.25/2.75))*(_td-(2.25/2.75)) + 0.9375) + _b;
} else {
    _ret = _c*(7.5625*(_td-(2.625/2.75))*(_td-(2.625/2.75)) + 0.984375) + _b;
}

return _ret;
