package com.example.flutter_printer_sdk;

import android.os.Build;

import androidx.annotation.NonNull;

import com.imin.library.IminSDKManager;
import com.imin.library.SystemPropManager;
import com.imin.printerlib.IminPrintUtils;

import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.imin.printersdk";
    private static MethodChannel.Result scanResult;

    private IminPrintUtils.PrintConnectType connectType = IminPrintUtils.PrintConnectType.USB;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("sdkInit")) {
                        String deviceModel = SystemPropManager.getModel();
                        if(deviceModel.contains("M")){
                            connectType = IminPrintUtils.PrintConnectType.SPI;
                        }
                        IminPrintUtils.getInstance(MainActivity.this).initPrinter(connectType);
                        result.success("init");
                    }else if(call.method.equals("getStatus")){
                        int status =
                                IminPrintUtils.getInstance(MainActivity.this).getPrinterStatus(connectType);
                        result.success(String.format("%d",status));
                    }else if(call.method.equals("printText")){
                        if(call.arguments() == null) return;
                        String text = ((List)call.arguments()).get(0).toString();
                        IminPrintUtils mIminPrintUtils =
                                IminPrintUtils.getInstance(MainActivity.this);
                        mIminPrintUtils.printText(text + "   \n");
                        result.success(text);
                    }else if(call.method.equals("getSn")){
                        String sn = "";
                        if (Build.VERSION.SDK_INT >= 30) {
                            sn = SystemPropManager.getSystemProperties("persist.sys.imin.sn");
                        } else {
                            sn = SystemPropManager.getSn();
                        }
                        result.success(sn);
                    }else if(call.method.equals("opencashBox")){
                        IminSDKManager.opencashBox();
                        result.success("opencashBox");
                    }
                }
        );
    }
}
