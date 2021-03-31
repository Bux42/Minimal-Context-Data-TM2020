#name "My first script"
#author "Bux"
#category "Cool"

bool running = false;
int prevTime = 0;
CGameCtnApp@ app = GetApp();
auto playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);
CSmScriptPlayer@ sm_script = cast<CSmPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer).ScriptAPI;

int menuScale = 4;

int menuPosX = 840;
int menuPosY = 500;

int menuHeight = 32 * menuScale;
int menuWidth = 64 * menuScale;

int renderPosY;

void Main()
{
    print("Bux - Init");
    
    auto playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);
    if (playgroundScript != null) {
        running = true;
    } else {
        print("playground is null");
    }
}

void RenderSteering()
{
    int startX;
    int startY;

    float max = 1;
    float mw = menuWidth / 2;
    float step = max / mw;

    if (sm_script.InputSteer > 0) {
        startX = menuPosX + (menuWidth / 2);
        startY = renderPosY;
        for (float i = 0; i < max; i += step) {
            if (sm_script.InputSteer > i) {
                nvg::BeginPath();
                nvg::Rect(startX, startY, 1, menuScale);
                nvg::FillColor(vec4(0.5,1,0.1,1));
                nvg::Fill();
                nvg::ClosePath();
                startX++;
            }
        }
    } else if (sm_script.InputSteer < 0) {
        startX = menuPosX + (menuWidth / 2) - 1;
        startY = renderPosY;
        for (float i = 0; i < max; i += step) {
            if (sm_script.InputSteer * -1 > i) {
                nvg::BeginPath();
                nvg::Rect(startX, startY, 1, menuScale);
                nvg::FillColor(vec4(0.5,1,0.1,1));
                nvg::Fill();
                nvg::ClosePath();
                startX--;
            }
        }
    }
    
}

void RenderSquare()
{
    nvg::BeginPath();
    nvg::Rect(menuPosX, menuPosY, menuWidth, menuHeight);
    nvg::FillColor(vec4(0.3,0.3,0.3,1));
    nvg::Fill();
    nvg::ClosePath();
}

void RenderAccelerate()
{
    if (sm_script.InputGasPedal != 0) {
        int posX = menuPosX + (menuWidth / 2);
        int posY = renderPosY;
        nvg::BeginPath();
        nvg::Rect(posX, posY, menuScale, menuScale);
        nvg::FillColor(vec4(0,1,0,1));
        nvg::Fill();
        nvg::ClosePath();
    }
}

void RenderBrake()
{
    if (sm_script.InputIsBraking) {
        int posX = menuPosX + (menuWidth / 2) - menuScale;
        int posY = renderPosY;
        nvg::BeginPath();
        nvg::Rect(posX, posY, menuScale, menuScale);
        nvg::FillColor(vec4(1,0,0,1));
        nvg::Fill();
        nvg::ClosePath();
    }
}

void RenderSpeed()
{
    float max = 277.5;
    float mw = menuWidth;
    float step = max / mw;

    int startX = menuPosX;
    int startY = renderPosY;
    for (float i = 0; i < max; i += step) {
        if (sm_script.Speed > i) {
            nvg::BeginPath();
            nvg::Rect(startX, startY, 1, menuScale);
            nvg::FillColor(vec4(1,1,1,1));
            nvg::Fill();
            nvg::ClosePath();
            startX++;
        }
    }
}

void RenderGears()
{
    int startX = menuPosX;
    int startY = renderPosY;
    int gearWidth = (menuWidth / 6);
    bool reached = false;
    for (int i = 0; i < 6; i++) {
        if (sm_script.EngineCurGear == i) {
            reached = true;
            nvg::BeginPath();
            nvg::Rect(startX, startY, gearWidth, menuScale);
            nvg::FillColor(vec4(0,1,1,1));
            nvg::Fill();
            nvg::ClosePath();
        } else {
            if (reached) {
                nvg::BeginPath();
                nvg::Rect(startX, startY, gearWidth, menuScale);
                nvg::FillColor(vec4(0.6,0.6,0.6,1));
                nvg::Fill();
                nvg::ClosePath();
            } else {
                nvg::BeginPath();
                nvg::Rect(startX, startY, gearWidth, menuScale);
                nvg::FillColor(vec4(0,0.8,1,1));
                nvg::Fill();
                nvg::ClosePath();
            }
        }
        startX += gearWidth + 1;
    }
}

void RenderRPM()
{
    float max = 11000;
    float mw = menuWidth;
    float step = max / mw;

    int startX = menuPosX;
    int startY = renderPosY;
    for (float i = 0; i < max; i += step) {
        if (sm_script.EngineRpm > i) {
            nvg::BeginPath();
            nvg::Rect(startX, startY, 1, menuScale);
            nvg::FillColor(vec4(1,1,0,1));
            nvg::Fill();
            nvg::ClosePath();
            startX++;
        }
    }
}

void Render()
{
    if (running) {
        if (playgroundScript != null) {
            RenderSquare();
            renderPosY = menuPosY + 1;
            RenderSteering();
            renderPosY += menuScale + 1;
            RenderAccelerate();
            RenderBrake();
            renderPosY += menuScale + 1;
            RenderSpeed();
            renderPosY += menuScale + 1;
            RenderGears();
            renderPosY += menuScale + 1;
            RenderRPM();
            renderPosY += menuScale + 1;
            int time = playgroundScript.Now - sm_script.StartTime;
            //print("Now - Start: " + time + ", CurrentRaceTime: " + (sm_script.CurrentRaceTime) + "Steer: " +  sm_script.InputSteer);
            prevTime = time;
            //print("Steer: " +  sm_script.InputSteer + ", Accel:" + sm_script.InputGasPedal + ", Brake: " + sm_script.InputIsBraking + ", DisplaySpeed: " + sm_script.DisplaySpeed+ ", Speed: " + sm_script.Speed);
            print("AimYaw: " +  sm_script.AimYaw   + ", AimPitch: " + sm_script.AimPitch);
        } else {
            print("playground is null");
        }
    }
}

int GetRaceTime(CSmPlayer@ player)
{
    auto app = cast<CTrackMania>(GetApp());
    auto playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);
    if (playgroundScript is null) {
        return 0;
    }

    return playgroundScript.Now - player.ScriptAPI.StartTime;
}

void RenderMenu()
{
    
  if (UI::MenuItem("My first menu item!")) {
      running = !running;
    print("You clicked me!!");
    CGameCtnApp@ app = GetApp();
    
    auto playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);
    if (playgroundScript != null) {
        print("ok" + playgroundScript.Now);
    }
  }
}