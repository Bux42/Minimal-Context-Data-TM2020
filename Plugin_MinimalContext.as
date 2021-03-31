#name "My first script"
#author "Bux"
#category "Cool"

bool running = false;
int prevTime = 0;
CGameCtnApp@ app = GetApp();
auto playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);
CSmScriptPlayer@ sm_script = cast<CSmPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer).ScriptAPI;

int menuPosX = 100;
int menuPosY = 100;

int menuHeight = 64;
int menuWidth = 64;

void Main()
{
    print("Bux - Init");
    
    auto playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);
    if (playgroundScript != null) {
        print("ok" + playgroundScript.Now);
        CSmScriptPlayer@ sm_script = cast<CSmPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer).ScriptAPI;
        print("" + (playgroundScript.Now - sm_script.StartTime));
        running = true;
    } else {
        print("playground is null");
    }
}

void RenderSteering()
{
    int startX;
    int startY;
    if (sm_script.InputSteer > 0) {
        startX = menuPosX + 32;
        startY = menuPosY;
        for (float i = 0; i < 1; i += 0.03125) {
            if (sm_script.InputSteer > i) {
                nvg::BeginPath();
                nvg::Rect(startX, startY, 1, 1);
                nvg::FillColor(vec4(1,0,1,1));
                nvg::Fill();
                nvg::ClosePath();
                startX++;
            }
        }
    } else if (sm_script.InputSteer < 0) {
        startX = menuPosX + 31;
        startY = menuPosY;
        for (float i = 0; i < 1; i += 0.03125) {
            if (sm_script.InputSteer * -1 > i) {
                nvg::BeginPath();
                nvg::Rect(startX, startY, 1, 1);
                nvg::FillColor(vec4(1,0,1,1));
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
    nvg::Rect(menuPosX, menuPosY, menuHeight, menuWidth);
    nvg::FillColor(vec4(1,1,1,1));
    nvg::Fill();
    nvg::ClosePath();
}

void RenderAccelerate()
{
    if (sm_script.InputGasPedal != 0) {
        int posX = menuPosX + 32;
        int posY = menuPosY + 1;
        nvg::BeginPath();
        nvg::Rect(posX, posY, 1, 1);
        nvg::FillColor(vec4(0,1,0,1));
        nvg::Fill();
        nvg::ClosePath();
    }
}

void RenderBrake()
{
    if (sm_script.InputIsBraking) {
        int posX = menuPosX + 31;
        int posY = menuPosY + 1;
        nvg::BeginPath();
        nvg::Rect(posX, posY, 1, 1);
        nvg::FillColor(vec4(1,0,0,1));
        nvg::Fill();
        nvg::ClosePath();
    }
}

void Render()
{
    if (running) {
        if (playgroundScript != null) {
            RenderSquare();
            RenderSteering();
            RenderAccelerate();
            RenderBrake();
            int time = playgroundScript.Now - sm_script.StartTime;
            //print("Now - Start: " + time + ", CurrentRaceTime: " + (sm_script.CurrentRaceTime) + "Steer: " +  sm_script.InputSteer);
            prevTime = time;
            print("Steer: " +  sm_script.InputSteer + ", Accel:" + sm_script.InputGasPedal + ", Brake: " + sm_script.InputIsBraking+ ", DisplaySpeed: " + sm_script.DisplaySpeed);
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