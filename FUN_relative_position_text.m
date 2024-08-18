function m_gct = FUN_relative_position_text(rx, ry, textstr,varargin)
% V1.2 by Lequan Chi 2022-05-17:
%      fix a bug: in early versions of matlab, "get(gca,'ylim')" returns
%      values in single format the command "text" requires double variables input
%
% V1.1 By Lequan Chi 2015-06-21
% Update: add m_gct;
%

xlimit = double( get(gca,'xlim') );
ylimit = double( get(gca,'ylim') );

x0 = xlimit(1) + rx*( xlimit(2)-xlimit(1) );
y0 = ylimit(1) + ry*( ylimit(2)-ylimit(1) );

m_gct = text(x0,y0,textstr,varargin{:});


