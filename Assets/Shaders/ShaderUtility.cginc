#ifndef shader_utility
#define shader_utility

#define PI 3.141592653589793

// Calculation 
float map(float value, float low1, float high1, float low2, float high2) {
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
}

// Noise

// http://nn-hokuson.hatenablog.com/entry/2017/01/27/195659
float random (fixed2 p)
{
    return frac(sin(dot(p, fixed2(12.9898,78.233))) * 43758.5453);
}

float blockNoise (fixed2 st)
{
    fixed2 p = floor(st);
    return random(p);
}

float valueNoise(fixed2 st)
{
    fixed2 p = floor(st);
    fixed2 f = frac(st);

    float v00 = random(p+fixed2(0,0));
    float v10 = random(p+fixed2(1,0));
    float v01 = random(p+fixed2(0,1));
    float v11 = random(p+fixed2(1,1));
    
    fixed2 u = f * f * (3.0 - 2.0 * f);            

    float v0010 = lerp(v00, v10, u.x);
    float v0111 = lerp(v01, v11, u.x);
    return lerp(v0010, v0111, u.y);
}

fixed2 dotedRandom(fixed2 st){
    st = fixed2( dot(st,fixed2(127.1,311.7)),
                    dot(st,fixed2(269.5,183.3)) );
    return -1.0 + 2.0*frac(sin(st)*43758.5453123);
}

float perlinNoise(fixed2 st) 
{
    fixed2 p = floor(st);
    fixed2 f = frac(st);
    fixed2 u = f*f*(3.0-2.0*f);

    float v00 = dotedRandom(p+fixed2(0,0));
    float v10 = dotedRandom(p+fixed2(1,0));
    float v01 = dotedRandom(p+fixed2(0,1));
    float v11 = dotedRandom(p+fixed2(1,1));

    return lerp( lerp( dot( v00, f - fixed2(0,0) ), dot( v10, f - fixed2(1,0) ), u.x ),
                    lerp( dot( v01, f - fixed2(0,1) ), dot( v11, f - fixed2(1,1) ), u.x ), 
                    u.y) + 0.5;
}

float fBm (fixed2 st) 
{
    float f = 0;
    fixed2 q = st;

    f += 0.5000 * perlinNoise( q );
    q *= 2.01;
    f += 0.2500 * perlinNoise( q );
    q *= 2.02;
    f += 0.1250 * perlinNoise( q );
    q *= 2.03;
    f += 0.0625 * perlinNoise( q );
    q *= 2.01;

    return f;
}

#endif