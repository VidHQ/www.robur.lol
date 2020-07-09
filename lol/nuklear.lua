require("utils.clean")
clean.module("nuklear", clean.seeall)

NK_WINDOW_BORDER            = 0x1
NK_WINDOW_MOVABLE           = 0x2
NK_WINDOW_SCALABLE          = 0x4
NK_WINDOW_CLOSABLE          = 0x8
NK_WINDOW_MINIMIZABLE       = 0x10
NK_WINDOW_NO_SCROLLBAR      = 0x20
NK_WINDOW_TITLE             = 0x40
NK_WINDOW_SCROLL_AUTO_HIDE  = 0x80
NK_WINDOW_BACKGROUND        = 0x100
NK_WINDOW_SCALE_LEFT        = 0x200
NK_WINDOW_NO_INPUT          = 0x400

local C = ffi.C

ffi.cdef[[
typedef uint32_t nk_uint;
typedef nk_uint nk_flags;
struct nk_rect {float x,y,w,h;};

struct nk_rect nk_rect(float x, float y, float w, float h);
int nk_begin(void *ctx, const char *title, struct nk_rect bounds, nk_flags flags);
void nk_layout_row_dynamic(void *ctx, float height, int cols);
nk_flags nk_edit_string(void *ctx, nk_flags, char *buffer, int *len, int max, void *nk_plugin_filter);
int nk_button_text(void *ctx, const char *title, int len);
int nk_button_label(void *ctx, const char *title);
void nk_end(struct nk_context *ctx);
]]

function test(ctx)
	local flags = bit.bor(NK_WINDOW_BORDER, NK_WINDOW_NO_SCROLLBAR, NK_WINDOW_MOVABLE)
	if C.nk_begin (ctx, "Calculator", C.nk_rect(10, 10, 180, 250), flags) > 0 then
--		C.nk_layout_row_dynamic (ctx, 35.0, 1)
--		if C.nk_button_label (ctx, "Button") == 1 then
--			INFO ("Button pressed")
--		end
		C.nk_end (ctx)
	end
end

return _M
