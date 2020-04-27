package companycoba.ta_dypos;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
// import java.companycoba.ta_andypos.adapter;
// import br.com.samhaus.escposprinter.adapter.USBPrinterAdapter;
// import java.companycoba.ta_andypos.adapter.USBPrinterAdapter;
// import java.util.List;
// import java.util.ArrayList;
// import java.util.HashMap;

public class MainActivity extends FlutterActivity {
	//  private static USBPrinterAdapter adapter;
  /**
   * Plugin registration.
   */
  // public static void registerWith(Registrar registrar) {
  //   final MethodChannel channel = new MethodChannel(registrar.messenger(), "escposprinter");
  //   channel.setMethodCallHandler(new EscposprinterPlugin());

  //   adapter = USBPrinterAdapter.getInstance();
  //   adapter.init(registrar.activity());
  // }

  // public void onMethodCall(MethodCall call, Result result) {
  //   if (call.method.equals("getUSBDeviceList")) {
  //     getUSBDeviceList(result);
  //   } else if (call.method.equals("connectPrinter")) {
  //     Integer vendor = call.argument("vendor");
  //     Integer product = call.argument("product");
  //     connectPrinter(vendor, product, result);
  //   } else if (call.method.equals("closeConn")) {
  //     closeConn(result);
  //   } else if (call.method.equals("printText")) {
  //     String text = call.argument("text");
  //     printText(text, result);
  //   } else if (call.method.equals("printRawData")) {
  //     String raw = call.argument("raw");
  //     printRawData(raw, result);
  //   } else {
  //     result.notImplemented();
  //   }
  // }

  //   public void getUSBDeviceList(Result result) {
  //       List<UsbDevice> usbDevices = adapter.getDeviceList();
  //       ArrayList<HashMap> list = new ArrayList<HashMap>();
  //       for (UsbDevice usbDevice : usbDevices) {
  //           HashMap<String, String> deviceMap = new HashMap();
  //           deviceMap.put("name", usbDevice.getDeviceName());
  //           deviceMap.put("manufacturer", usbDevice.getManufacturerName());
  //           deviceMap.put("product", usbDevice.getProductName());
  //           deviceMap.put("deviceid", Integer.toString(usbDevice.getDeviceId()));
  //           deviceMap.put("vendorid", Integer.toString(usbDevice.getVendorId()));
  //           deviceMap.put("productid", Integer.toString(usbDevice.getProductId()));
  //           list.add(deviceMap);
  //       }
  //       result.success(list);
  //   }


  //   public void connectPrinter(Integer vendorId, Integer productId, Result result) {
  //       if(!adapter.selectDevice(vendorId, productId)){
  //         result.success(false);
  //       }else{
  //         result.success(true);
  //       }
  //   }


  //   public void closeConn(Result result) {
  //       adapter.closeConnectionIfExists();
  //       result.success(true);
  //   }


  //   public void printText(String text, Result result) {
  //       adapter.printText(text);
  //       result.success(true);
  //   }

  //   public void printRawData(String base64Data, Result result) {
  //       adapter.printRawData(base64Data);
  //       result.success(true);
  //   }
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
