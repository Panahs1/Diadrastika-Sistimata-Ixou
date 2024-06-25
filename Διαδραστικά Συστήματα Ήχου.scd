s.waitForBoot {
    SynthDef(\kick, {
        |out=0, dur=0.4, amp=0.8, pan=0|
        var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
        var sig = SinOsc.ar(50, 0, amp) * env;
        sig = sig + CombN.ar(sig, 0.2, 0.2, 2) * 0.3; // Προσθήκη reverb
        Out.ar(out, Pan2.ar(sig, pan));
    }).add;

    SynthDef(\snare, {
        |out=0, dur=0.4, amp=0.7, pan=0|
        var noise = WhiteNoise.ar;
        var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
        var sig = HPF.ar(BRF.ar(noise, 5000, 0.1), 1000) * env;
        sig = sig + CombN.ar(sig, 0.2, 0.2, 2) * 0.3;
        Out.ar(out, Pan2.ar(sig * amp, pan));
    }).add;

    SynthDef(\hihat, {
        |out=0, dur=0.2, amp=0.6, pan=0|
        var noise = WhiteNoise.ar;
        var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
        var sig = HPF.ar(noise, 8000) * env;
        sig = sig + CombN.ar(sig, 0.1, 0.1, 2) * 0.2;
        Out.ar(out, Pan2.ar(sig * amp, pan));
    }).add;

    SynthDef(\piano, {
        |out=0, freq=440, dur=0.4, amp=0.8, pan=0|
        var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
        var snd = Mix.fill(2, { |i|
            var detune = [0.98, 1.02];
            var sig = SinOsc.ar(freq * detune[i], 0) * env * amp;
            Pan2.ar(sig, pan);
        });
        snd = snd + CombN.ar(snd, 0.3, 0.3, 2) * 0.3;
        Out.ar(out, snd);
    }).add;

    SynthDef(\flute, {
        |out=0, freq=440, dur=1, amp=0.4, pan=0|
        var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
        var sig = Mix.fill(2, { |i|
            var detune = [0.99, 1.01];
            var sig = SinOsc.ar(freq * detune[i], 0) * env * amp;
            Pan2.ar(sig, pan);
        });
        sig = sig + CombN.ar(sig, 0.3, 0.3, 2) * 0.3;
        Out.ar(out, sig);
    }).add;

    SynthDef(\melody, {
        |out=0, freq=440, dur=0.2, amp=0.7, pan=0|
        var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
        var sig = Saw.ar(freq, 0.2) * env * amp;
        sig = sig + CombN.ar(sig, 0.2, 0.2, 2) * 0.3;
        Out.ar(out, Pan2.ar(sig, pan));
    }).add;

    Pbind(
        \instrument, Pseq([\kick, \melody, \snare, \hihat, \piano, \flute], inf),
        \dur, Pseq([0.4, 0.2, 0.4, 0.2, 0.4, 1, 0.3, 0.1], inf),
        \amp, Pseq([0.8, 0.7, 0.6, 0.8, 0.4, 0.7, 0.9, 0.5], inf),
        \freq, Pseq([60, 62, 64, 65, 67, 69, 71, 72, 74, 76], inf),
        \pan, Pseq([-0.5, 0.5, -0.3, 0.3, -0.7, 0.7, 0, 0], inf)
    ).play;

    60.wait;
    Pdef.all.do(_.stop);
};
