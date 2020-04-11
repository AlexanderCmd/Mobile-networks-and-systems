function cX = modGx(m_rX, gX)
[~, r] = deconv(m_rX, gX);
cX = mod(r, 2);