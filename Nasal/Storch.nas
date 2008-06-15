var F_Switch = props.globals.getNode("controls/fuel/switch-position",2);
var FDM=0;

var strobe_switch = props.globals.getNode("controls/lighting/strobe", 1);
aircraft.light.new("controls/lighting/strobe-state", [0.05, 1.30], strobe_switch);

var beacon_switch = props.globals.getNode("controls/lighting/beacon", 1);
aircraft.light.new("controls/lighting/beacon-state", [1.0, 1.0], beacon_switch);

setlistener("/sim/signals/fdm-initialized", func {
    F_Switch.setIntValue(-1);
    setprop("consumables/fuel/tank[0]/selected",1);
    setprop("consumables/fuel/tank[1]/selected",1);
    setup_start();
    FDM=1;
#    update();
});

setlistener("/sim/signals/reinit", func {
    if(cmdarg().getValue()==0){
    setup_start();
    }
});

setlistener("controls/fuel/switch-position", func {
    var position=cmdarg().getValue();
    setprop("consumables/fuel/tank[0]/selected",0);
    setprop("consumables/fuel/tank[1]/selected",0);
    if(position == 1 or position == 2){
        setprop("consumables/fuel/tank[0]/selected",1);
    };
    if(position == 2 or position == 3){
        setprop("consumables/fuel/tank[1]/selected",1);
    };
},1);

setlistener("controls/electric/circuitbreaker/cb_0_1", func {
    if (cmdarg().getBoolValue()) {
	    setprop("instrumentation/marker-beacon/power-btn",0);
    } else {
	    setprop("instrumentation/marker-beacon/power-btn",1);
    }
});

setlistener("controls/electric/circuitbreaker/cb_0_6", func {
    if (cmdarg().getBoolValue()) {
	    setprop("/sim/view/dynamic/enabled",0);
    } else {
	    setprop("/sim/view/dynamic/enabled",1);
    }
});



var oil_temp = func{
    if(getprop("engines/engine/running") != 0){
        interpolate("engines/engine/oil-temp-norm", 0.7 + (getprop("/controls/engines/engine/throttle")* 0.3), 300);
    }else{
        interpolate("engines/engine/oil-temp-norm", 0.0, 1000);
    }
}


setup_start = func{

}


update = func {
    oil_temp();
    settimer(update,0);
}

