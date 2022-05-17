package com.ly.flutter_mob_t;

import com.mob.MobSDK;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.wechat.friends.Wechat;
// import cn.smssdk.EventHandler
import cn.smssdk.EventHandler;
import cn.smssdk.SMSSDK;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterMobTPlugin implements MethodCallHandler {

    private Registrar registrar;

    private FlutterMobTPlugin(Registrar registrar) {
        this.registrar = registrar;
    }

    private Handler handler = new Handler();

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_mob_t");
        channel.setMethodCallHandler(new FlutterMobTPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        Listener listener = new Listener();
        switch (call.method) {
            case "init":
                String appKey = call.argument("appKey");
                String appSecret = call.argument("appSecret");
                MobSDK.init(registrar.activity(), appKey, appSecret);
                SMSSDK.registerEventHandler(handler);
                result.success(null);
                break;
            case "getCode":
                handler.setResult(result);
                String phone = call.argument("phone");
                SMSSDK.getVerificationCode("+86", phone);
                break;
            case "commitCode":
                handler.setResult(result);
                String phone1 = call.argument("phone");
                String code = call.argument("code");
                SMSSDK.submitVerificationCode("+86", phone1, code);
                break;
            case "register":
                break;
            case "auth":
                int type = (int) call.arguments;
                String name = "";
                switch (type) {
                    case 997:
                        name = Wechat.NAME;
                        break;
                    case 998:
                        name = QQ.NAME;
                        break;
                    case 1:
                        name = SinaWeibo.NAME;
                        break;
                }
                listener.setResult(result);
                Platform qqPlatform = ShareSDK.getPlatform(name);
                qqPlatform.setPlatformActionListener(listener);
                qqPlatform.authorize();
                break;
            case "share":
                String title = call.argument("title");
                String text = call.argument("text");
                String imagePath = call.argument("imagePath");
                String url = call.argument("url");
                String titleUrl = call.argument("titleUrl");
                showShare(title, text, imagePath, url, titleUrl);
                result.success(null);
                break;
        }
    }

    private class Handler extends EventHandler {
        private Result result;

        void setResult(Result result) {
            this.result = result;
        }

        @Override
        public void afterEvent(int event, int i, final Object data) {
            if (i == SMSSDK.RESULT_COMPLETE) {
                //回调完成
                switch (event) {
                    case SMSSDK.EVENT_GET_VERIFICATION_CODE:
                        //获取验证码成功
                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                HashMap<String, Object> get = new HashMap<>();
                                get.put("status", 0);
                                get.put("msg", "success");
                                result.success(get);
                            }
                        });
                        break;
                    case SMSSDK.EVENT_SUBMIT_VERIFICATION_CODE:
                        //提交验证码成功
                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                HashMap<String, Object> commit = new HashMap<>();
                                commit.put("status", 0);
                                commit.put("msg", "success");
                                result.success(commit);
                            }
                        });
                        break;
                }
            } else {
                registrar.activity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            JSONObject json = new JSONObject(((Throwable) data).getMessage());
                            HashMap<String, Object> map = new HashMap<>();
                            map.put("status", 1);
                            map.put("msg", json.getString("detail"));
                            result.success(map);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                });
            }
        }
    }

    private class Listener implements PlatformActionListener {

        private Result result;

        void setResult(Result result) {
            this.result = result;
        }

        @Override
        public void onComplete(final Platform platform, int i, HashMap<String, Object> hashMap) {
            registrar.activity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    HashMap<String, Object> data = new HashMap<>();
                    data.put("uid", platform.getDb().getUserId());
                    data.put("nickname", platform.getDb().getUserName());
                    data.put("icon", platform.getDb().getUserIcon());
                    HashMap<String, Object> map = new HashMap<>();
                    map.put("status", 0);
                    map.put("msg", "success");
                    map.put("data", data);
                    result.success(map);
                }
            });
        }

        @Override
        public void onError(final Platform platform, int i, final Throwable throwable) {
            registrar.activity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    HashMap<String, Object> map = new HashMap<>();
                    map.put("status", 1);
                    map.put("msg", throwable.getMessage());
                    result.success(map);
                }
            });
        }

        @Override
        public void onCancel(Platform platform, int i) {
            registrar.activity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    HashMap<String, Object> map = new HashMap<>();
                    map.put("status", 2);
                    map.put("msg", "cancel");
                    result.success(map);
                }
            });
        }
    }

    private void showShare(String title, String text, String imagePath, String url, String titleUrl) {
        OnekeyShare oks = new OnekeyShare();
        //关闭sso授权
        oks.disableSSOWhenAuthorize();
        // title标题，微信、QQ和QQ空间等平台使用
        oks.setTitle(title);
        // text是分享文本，所有平台都需要这个字段
        oks.setText(text);
        // imagePath是图片的本地路径，Linked-In以外的平台都支持此参数
        if (imagePath != null) {
            oks.setImagePath(imagePath);
        }
        // url在微信、微博，Facebook等平台中使用
        if (url != null) {
            oks.setUrl(url);
        }
        // titleUrl QQ和QQ空间跳转链接
        if (titleUrl != null) {
            oks.setTitleUrl(titleUrl);
        }
        // comment是我对这条分享的评论，仅在人人网使用
        // oks.setComment("我是测试评论文本");
        // 启动分享GUI
        oks.show(registrar.activity());
    }
}