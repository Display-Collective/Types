public class FPreferences {
  // -----------------------------------------------------------------------------
  //
  // Properties
  //
  // -----------------------------------------------------------------------------
  PApplet p5;

  private JSONArray src;
  private JSONObject data;

  private String filename;
  private String path;


  // -----------------------------------------------------------------------------
  //
  // Constructor
  //
  // -----------------------------------------------------------------------------
  public FPreferences(PApplet papplet, String filename) {
    this.p5 = papplet;
    this.filename = filename;
    reload();
  }



  // -----------------------------------------------------------------------------
  //
  // Methods
  //
  // -----------------------------------------------------------------------------
  public void reload() {
    data = loadJSONObject(filename);
  }

  public boolean save() {

    // push out to server
    boolean isSuccess = false;
    DataUpload upload = new DataUpload();
    isSuccess = upload.UploadTextData(p5.sketchPath + "/data/preferences.json", "text");

    // save local version
    saveJSONObject(data, path + filename);

    if (isSuccess ) {
      // Get the answer of the PHP script
      int rc = upload.GetResponseCode();
      String feedback = upload.GetServerFeedback();
      println("-----------------------------------------------------------------------------");
      println(rc + "\n" + feedback);
      println("-----------------------------------------------------------------------------");

      return true;
    }
    else {
      println("ERROR: preferences upload");
      return false;
    }    
  }

  //
  // Sets
  //
  public void setPath(String path) {
    this.path = path;
  }
  
  // -----------------------------------------------------------------------------
  public boolean setInt(String name, int val) {
    data.setFloat(name, val);
    return saveJSONObject(data, path + filename);
  }
  
  public boolean setFloat(String name, float val) {
    data.setFloat(name, val);
    return saveJSONObject(data, path + filename);
  }

  public boolean setString(String name, String val) {
    data.setString(name, val);
    return saveJSONObject(data, path + filename);
  }

  public void setIntArray(String name, int[] val) {
    JSONArray out = new JSONArray();
    for (int i=0; i<val.length; i++) {
      out.setInt(i, val[i]);
    }
    data.setJSONArray(name, out);
  }

  
  //
  // Gets
  //
  public int getInt(String name) {
    return data.getInt(name);
  }

  public float getFloat(String name) {
    return data.getFloat(name);
  }

  public String getString(String name) {
    try {
      return data.getString(name);
    }
    catch (Exception e) {
      return Float.toString(data.getFloat(name));
    }
  }
  
  public boolean getBoolean(String name) {
    return data.getBoolean(name);
  }

  public int[] getIntArray(String name) {
    return data.getJSONArray(name).getIntArray();
  }

  public float[] getFloatArray(String name) {
    return data.getJSONArray(name).getFloatArray();
  }

  public String[] getStringArray(String name) {
    return data.getJSONArray(name).getStringArray();
  }

  public boolean[] getBooleanArray(String name) {
    return data.getJSONArray(name).getBooleanArray();
  }

} 
