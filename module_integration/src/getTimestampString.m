function [ timestamp] = getTimestampString( )
%GET Summary of this function goes here
%   Detailed explanation goes here

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

end

