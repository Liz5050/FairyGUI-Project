using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using XLua;

public class RunLua : MonoBehaviour
{
    private LuaEnv _LuaEnv;
    // Start is called before the first frame update
    void Start()
    {
        _LuaEnv = new LuaEnv();
        //_LuaEnv.DoString("print('Will You Marry Me')");//DoString里的字符串为lua程序,DoString运行里面的语法程序
        _LuaEnv.AddLoader(luaLoader);
        _LuaEnv.DoString("require 'Main'");
    }

    // Update is called once per frame
    void Update()
    {
        if(_LuaEnv != null)
		{
			_LuaEnv.Tick();
		}
    }

    private void OnDestroy()
    {
        _LuaEnv.Dispose();
    }

    byte[] luaLoader(ref string filename)
    {
        string path = Application.dataPath + "/Lua/" + filename + ".lua";
        if (File.Exists(path))
        {
            byte[] content = File.ReadAllBytes(path);
            return content;
        }
        return null;
    }
}
