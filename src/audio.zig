const std = @import("std");

const sdl = @cImport({
    @cInclude("SDL3/SDL.h");
    @cInclude("SDL3/SDL_main.h");
});

var stream: ?*sdl.SDL_AudioStream = null;
var current_sine_sample: i32 = 0;

pub fn ntv_init() bool {
    var spec: sdl.SDL_AudioSpec = undefined;

    _ = sdl.SDL_SetAppMetadata("Example Audio Simple Playback", "1.0", "com.example.audio-simple-playback");
    std.debug.print("initia\n", .{});

    if (sdl.SDL_Init(sdl.SDL_INIT_AUDIO) == false) {
        std.debug.print("Couldn't initialize SDL: {*}", .{sdl.SDL_GetError()});

        return false;
    }
    std.debug.print("init complete", .{});

    spec.channels = 1;
    spec.format = sdl.SDL_AUDIO_F32;
    spec.freq = 8000;
    stream = sdl.SDL_OpenAudioDeviceStream(sdl.SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &spec, null, null);
    if (stream == null) {
        sdl.SDL_Log("Couldn't create audio stream: %s", sdl.SDL_GetError());
        return false;
    }

    _ = sdl.SDL_ResumeAudioStreamDevice(stream);
    return true;
}

pub fn ntv_trigger_sound() void {
    const minimum_audio = (8000 * @sizeOf(f32)) / 2;
    if (sdl.SDL_GetAudioStreamQueued(stream) < minimum_audio) {
        var samples: [512]f32 = undefined;
        const freq = 440;
        for (&samples) |*sample| {
            const phase = @as(f32, @floatFromInt(current_sine_sample)) * @as(f32, freq) / 8000.0;
            sample.* = sdl.SDL_sinf(phase * 2 * sdl.SDL_PI_F);
            current_sine_sample += 1;
        }
        current_sine_sample = @mod(current_sine_sample, 8000);
        _ = sdl.SDL_PutAudioStreamData(stream, &samples, @sizeOf(@TypeOf(samples)));
    }
}

pub fn ntv_quit() void {
    sdl.SDL_Quit();
}
