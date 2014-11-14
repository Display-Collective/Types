/*     */ import java.applet.Applet;
/*     */ import java.applet.AppletContext;
/*     */ import java.awt.Component;
/*     */ import java.awt.Dimension;
/*     */ import java.awt.Event;
/*     */ import java.awt.Graphics;
/*     */ import java.awt.Image;
/*     */ import java.awt.MediaTracker;
/*     */ import java.io.PrintStream;
/*     */ import java.net.MalformedURLException;
/*     */ import java.net.URL;
/*     */ 
/*     */ public class lake extends Applet
/*     */   implements Runnable
/*     */ {
/*     */   private int boatHeight;
/*  39 */   private boolean keepRunning = true;
/*     */   private transient Thread thrLake;
/*     */   private static final String PARAM_IMAGE = "image";
/*     */   private static final String PARAM_OVERLAY = "overlay";
/*     */   private static final String PARAM_TARGET = "target";
/*     */   private static final String PARAM_HREF = "hRef";
/*     */   private static final String PARAM_ROCKING = "rocking";
/*     */   private static final String PARAM_UNDERWATER = "underwater";
/*     */   private static final String PARAM_SPEED = "speed";
/*     */   private static final String PARAM_HORIZON = "horizon";
/*     */   private Image image;
/*     */   private Image overlay;
/*     */   private MediaTracker overlayTracker;
/* 226 */   private String target = "_self";
/*     */   private URL hRef;
/* 312 */   private boolean rocking = false;
/*     */ 
/* 347 */   private boolean underwater = false;
/*     */ 
/* 382 */   private int speed = 50;
/*     */ 
/* 418 */   private int horizon = -1;
/*     */ 
/* 504 */   private int numFrames = 12;
/*     */   private transient Graphics gMain;
/*     */   private transient Graphics gWave;
/*     */   private transient Image imgWave;
/*     */   private transient int currImage;
/*     */   private transient int widthImage;
/*     */   private transient int heightImage;
/*     */   private transient int widthOverlay;
/*     */   private transient int heightOverlay;
/* 511 */   private transient boolean allLoaded = false; private transient boolean isAnimating = true;
/*     */   private transient int boatPhase;
/* 513 */   private transient int boatPhaseTotal = 50;
/*     */ 
/*     */   public void start()
/*     */   {
/*  50 */     this.keepRunning = true;
/*  51 */     if (this.thrLake == null) {
/*  52 */       this.thrLake = new Thread(this);
/*  53 */       this.thrLake.start();
/*     */     }
/*     */   }
/*     */ 
/*     */   public void stop() {
/*  58 */     this.keepRunning = false;
/*     */   }
/*     */ 
/*     */   public void run() {
/*  62 */     this.currImage = 0;
/*  63 */     while (this.keepRunning)
/*     */       try {
/*  65 */         while (!this.isAnimating)
/*  66 */           Thread.sleep(500L);
/*  67 */         if (++this.currImage == this.numFrames)
/*  68 */           this.currImage = 0;
/*  69 */         if (++this.boatPhase == this.boatPhaseTotal)
/*  70 */           this.boatPhase = 0;
/*  71 */         displayImage();
/*  72 */         repaint();
/*  73 */         Thread.sleep(30L);
/*     */       }
/*     */       catch (InterruptedException localInterruptedException) {
/*  76 */         stop();
/*     */       }
/*     */   }
/*     */ 
/*     */   public String getAppletInfo()
/*     */   {
/*  87 */     return 
/*  94 */       "Name: lake Version 4.0\r\nAuthor: David Griffiths\r\nis an applet class which takes in an \r\nimage and reflects it in a virtual lake.\r\nLast compiled: 10th October 1999 at 13:17:27  \r\nFor more information about this and other applets\r\ngo to http://www.spigots.com/spigots.htm\r\nCreated with Sun JDK 1.1";
/*     */   }
/*     */ 
/*     */   public Image getImage()
/*     */   {
/* 126 */     return this.image;
/*     */   }
/*     */ 
/*     */   public void setImage(Image paramImage)
/*     */   {
/* 136 */     this.image = paramImage;
/* 137 */     this.widthImage = this.image.getWidth(this);
/* 138 */     this.heightImage = this.image.getHeight(this);
/* 139 */     this.allLoaded = true;
/* 140 */     createAnimation();
/*     */   }
/*     */ 
/*     */   public void setImageValue(String paramString)
/*     */   {
/* 151 */     setImage(getImage(getDocumentBase(), paramString));
/*     */   }
/*     */ 
/*     */   public boolean imageUpdate(Image paramImage, int paramInt1, int paramInt2, int paramInt3, int paramInt4, int paramInt5)
/*     */   {
/* 160 */     boolean bool = super.imageUpdate(paramImage, paramInt1, paramInt2, paramInt3, paramInt4, paramInt5);
/*     */ 
/* 162 */     if (paramImage == this.image) {
/* 163 */       int i = this.heightImage;
/*     */ 
/* 165 */       if ((paramInt1 & 0x30) != 0) {
/* 166 */         this.widthImage = paramInt4;
/* 167 */         this.heightImage = paramInt5;
/*     */       }
/*     */       else {
/* 170 */         this.widthImage = size().width;
/* 171 */         this.heightImage = (10 * size().height / 18);
/*     */       }
/* 173 */       if (i != this.heightImage) {
/* 174 */         createAnimation();
/*     */       }
/*     */     }
/* 177 */     return bool;
/*     */   }
/*     */ 
/*     */   public Image getOverlay()
/*     */   {
/* 195 */     return this.overlay;
/*     */   }
/*     */ 
/*     */   public void setOverlay(Image paramImage)
/*     */   {
/* 205 */     this.overlay = paramImage;
/* 206 */     this.overlayTracker = new MediaTracker(this);
/* 207 */     this.overlayTracker.addImage(paramImage, 0);
/*     */   }
/*     */ 
/*     */   public void setOverlayValue(String paramString) {
/* 211 */     setOverlay(getImage(getDocumentBase(), paramString));
/*     */   }
/*     */ 
/*     */   private boolean overlayReady() {
/* 215 */     if (this.overlayTracker != null) {
/* 216 */       return this.overlayTracker.statusID(0, true) == 8;
/*     */     }
/* 218 */     return false;
/*     */   }
/*     */ 
/*     */   public String getTarget()
/*     */   {
/* 235 */     return this.target;
/*     */   }
/*     */ 
/*     */   public void setTarget(String paramString)
/*     */   {
/* 245 */     this.target = paramString;
/*     */   }
/*     */ 
/*     */   public void setTargetValue(String paramString) {
/* 249 */     setTarget(paramString);
/*     */   }
/*     */ 
/*     */   public URL getHRef()
/*     */   {
/* 267 */     return this.hRef;
/*     */   }
/*     */ 
/*     */   public void setHRef(URL paramURL)
/*     */   {
/* 277 */     this.hRef = paramURL;
/*     */   }
/*     */ 
/*     */   public void setHRefValue(String paramString)
/*     */   {
/* 288 */     setHRef(createURL(paramString));
/*     */   }
/*     */ 
/*     */   private URL createURL(String paramString)
/*     */   {
/* 293 */     URL localURL = null;
/*     */ 
/* 295 */     if (paramString != null) {
/*     */       try {
/* 297 */         localURL = new URL(getDocumentBase(), paramString);
/*     */       }
/*     */       catch (MalformedURLException localMalformedURLException) {
/* 300 */         error("Bad URL: " + paramString);
/* 301 */         localURL = null;
/*     */       }
/*     */     }
/* 304 */     return localURL;
/*     */   }
/*     */ 
/*     */   public boolean isRocking()
/*     */   {
/* 321 */     return this.rocking;
/*     */   }
/*     */ 
/*     */   public void setRocking(boolean paramBoolean)
/*     */   {
/* 331 */     this.rocking = paramBoolean;
/*     */   }
/*     */ 
/*     */   public void setRockingValue(String paramString) {
/* 335 */     setRocking(paramString.toUpperCase().equals("TRUE"));
/*     */   }
/*     */ 
/*     */   public void toggleRocking() {
/* 339 */     setRocking(!isRocking());
/*     */   }
/*     */ 
/*     */   public boolean isUnderwater()
/*     */   {
/* 356 */     return this.underwater;
/*     */   }
/*     */ 
/*     */   public void setUnderwater(boolean paramBoolean)
/*     */   {
/* 366 */     this.underwater = paramBoolean;
/*     */   }
/*     */ 
/*     */   public void setUnderwaterValue(String paramString) {
/* 370 */     setUnderwater(paramString.toUpperCase().equals("TRUE"));
/*     */   }
/*     */ 
/*     */   public void toggleUnderwater() {
/* 374 */     setUnderwater(!isUnderwater());
/*     */   }
/*     */ 
/*     */   public int getSpeed()
/*     */   {
/* 391 */     return this.speed;
/*     */   }
/*     */ 
/*     */   public void setSpeed(int paramInt)
/*     */   {
/* 401 */     if (paramInt > 100)
/* 402 */       paramInt = 100;
/* 403 */     else if (paramInt < 1)
/* 404 */       paramInt = 1;
/* 405 */     this.speed = paramInt;
/* 406 */     this.numFrames = (600 / paramInt);
/*     */   }
/*     */ 
/*     */   public void setSpeedValue(String paramString) {
/* 410 */     setSpeed(Integer.parseInt(paramString));
/*     */   }
/*     */ 
/*     */   public int getHorizon()
/*     */   {
/* 427 */     return this.horizon;
/*     */   }
/*     */ 
/*     */   public void setHorizon(int paramInt)
/*     */   {
/* 437 */     if (paramInt > -2)
/* 438 */       this.horizon = paramInt;
/*     */   }
/*     */ 
/*     */   public void setHorizonValue(String paramString) {
/* 442 */     setHorizon(Integer.parseInt(paramString));
/*     */   }
/*     */ 
/*     */   public String[][] getParameterInfo()
/*     */   {
/* 447 */     String[][] arrayOfString; = { 
/* 448 */       { "image", "Image", "JPG or GIF file to reflect" }, 
/* 449 */       { "overlay", "Image", "JPG or GIF file to use as an overlay" }, 
/* 450 */       { "target", "String", "Target frame" }, 
/* 451 */       { "hRef", "URL", "URL to link to" }, 
/* 452 */       { "rocking", "boolean", "TRUE if boat rocking" }, 
/* 453 */       { "underwater", "boolean", "TRUE if viewer underwater" }, 
/* 454 */       { "speed", "int", "The animation speed: 1-100" }, 
/* 455 */       { "horizon", "int", "The horizon level: 0-height of image" } };
/*     */ 
/* 457 */     return arrayOfString;;
/*     */   }
/*     */ 
/*     */   private void loadParams()
/*     */   {
/* 463 */     String str = getParameter("horizon");
/* 464 */     if (str != null) {
/* 465 */       setHorizonValue(str);
/*     */     }
/* 467 */     str = getParameter("image");
/* 468 */     if (str != null) {
/* 469 */       setImageValue(str);
/*     */     }
/* 471 */     str = getParameter("overlay");
/* 472 */     if (str != null) {
/* 473 */       setOverlayValue(str);
/*     */     }
/* 475 */     str = getParameter("target");
/*     */ 
/* 477 */     str = getParameter("hRef");
/* 478 */     if (str != null)
/* 479 */       setHRefValue(str);
/*     */     else {
/* 481 */       setHRefValue("http://www.spigots.com/lake.htm");
/*     */     }
/* 483 */     str = getParameter("rocking");
/* 484 */     if (str != null) {
/* 485 */       setRockingValue(str);
/*     */     }
/* 487 */     str = getParameter("underwater");
/* 488 */     if (str != null) {
/* 489 */       setUnderwaterValue(str);
/*     */     }
/* 491 */     str = getParameter("speed");
/* 492 */     if (str != null)
/* 493 */       setSpeedValue(str);
/*     */   }
/*     */ 
/*     */   public boolean mouseUp(Event paramEvent, int paramInt1, int paramInt2) {
/* 497 */     if (this.hRef != null) {
/* 498 */       error(String.valueOf(this.hRef));
/* 499 */       getAppletContext().showDocument(this.hRef, this.target);
/*     */     }
/* 501 */     return true;
/*     */   }
/*     */ 
/*     */   public void init()
/*     */   {
/* 519 */     repaint();
/* 520 */     System.out.println(getAppletInfo());
/* 521 */     loadParams();
/* 522 */     this.allLoaded = true;
/*     */   }
/*     */ 
/*     */   public Dimension getPreferredSize()
/*     */   {
/* 529 */     return new Dimension(this.widthImage, 
/* 530 */       (int)(this.heightImage * 1.8D));
/*     */   }
/*     */ 
/*     */   private void error(String paramString)
/*     */   {
/* 541 */     getAppletContext().showStatus(paramString);
/*     */   }
/*     */ 
/*     */   public void update(Graphics paramGraphics)
/*     */   {
/* 550 */     paint(paramGraphics);
/*     */   }
/*     */ 
/*     */   public void paint(Graphics paramGraphics) {
/* 554 */     if (this.imgWave != null)
/* 555 */       paramGraphics.drawImage(this.imgWave, 0, this.boatHeight, this);
/*     */   }
/*     */ 
/*     */   private void displayImage()
/*     */   {
/* 560 */     if (isRocking())
/* 561 */       this.boatHeight = 
/* 563 */         ((int)
/* 563 */         (this.heightImage * 
/* 562 */         Math.sin(6.283185307179586D * this.boatPhase / this.boatPhaseTotal) / 
/* 563 */         8.0D) - this.heightImage / 8);
/*     */     else {
/* 565 */       this.boatHeight = 0;
/*     */     }
/* 567 */     if (this.imgWave != null) {
/* 568 */       if (isUnderwater()) {
/* 569 */         if (this.horizon >= 0) {
/* 570 */           this.gWave.drawImage(this.image, 0, 0, this);
/* 571 */           makeWavesInverseHorizon(this.gWave, this.currImage);
/*     */         }
/*     */         else {
/* 574 */           this.gWave.drawImage(this.image, 0, size().height - this.heightImage, this);
/* 575 */           makeWavesInverse(this.gWave, this.currImage);
/*     */         }
/* 577 */         this.boatHeight = (-this.boatHeight);
/*     */       }
/*     */       else {
/* 580 */         this.gWave.drawImage(this.image, 0, 0, this);
/* 581 */         if (this.horizon >= 0)
/* 582 */           makeWavesHorizon(this.gWave, this.currImage);
/*     */         else {
/* 584 */           makeWaves(this.gWave, this.currImage);
/*     */         }
/*     */       }
/* 587 */       if ((this.overlay != null) && 
/* 588 */         (overlayReady()))
/* 589 */         this.gWave.drawImage(this.overlay, 
/* 590 */           this.widthImage - this.overlay.getWidth(this) >> 1, 
/* 591 */           this.heightImage - (this.overlay.getHeight(this) >> 1) + 
/* 592 */           this.boatHeight, 
/* 593 */           this);
/*     */     }
/*     */   }
/*     */ 
/*     */   private void createAnimation() {
/* 598 */     if ((this.widthImage > 0) && (this.heightImage > 0)) {
/* 599 */       synchronized (this) {
/* 600 */         if (this.horizon >= 0)
/* 601 */           this.imgWave = createImage(2 * this.widthImage, 
/* 602 */             2 * this.heightImage);
/*     */         else
/* 604 */           this.imgWave = createImage(this.widthImage, 
/* 605 */             2 * this.heightImage);
/* 606 */         this.gWave = this.imgWave.getGraphics();
/* 607 */         if (this.horizon >= 0)
/* 608 */           this.gWave.drawImage(this.image, this.widthImage, 0, this);
/*     */       }
/*     */     }
/* 611 */     repaint();
/*     */   }
/*     */ 
/*     */   private void makeWaves(Graphics paramGraphics, int paramInt) {
/* 615 */     double d = 6.283185307179586D * paramInt / this.numFrames;
/* 616 */     for (int i = 0; i < this.heightImage; i++) {
/* 617 */       int j = (int)
/* 621 */         (this.heightImage / 14 * (
/* 618 */         i + 28.0D) * 
/* 619 */         Math.sin(this.heightImage / 14 * (this.heightImage - i) / (
/* 620 */         i + 1) + d) / 
/* 621 */         this.heightImage);
/*     */ 
/* 623 */       if (i - this.heightImage > j)
/* 624 */         paramGraphics.copyArea(0, this.heightImage - i, 
/* 625 */           this.widthImage, 1, 0, i << 1);
/*     */       else
/* 627 */         paramGraphics.copyArea(0, this.heightImage - i + j, 
/* 628 */           this.widthImage, 1, 0, (i << 1) - j);
/*     */     }
/*     */   }
/*     */ 
/*     */   private void makeWavesHorizon(Graphics paramGraphics, int paramInt) {
/* 633 */     double d = 6.283185307179586D * paramInt / this.numFrames;
/* 634 */     for (int i = this.horizon; i < this.heightImage; i++) {
/* 635 */       int j = (int)
/* 640 */         (this.heightImage / 14 * (
/* 636 */         i - this.horizon + 28.0D) * 
/* 637 */         Math.sin(this.heightImage / 14 * (
/* 638 */         this.heightImage - i + this.horizon) / (
/* 639 */         i - this.horizon + 1) + d) / 
/* 640 */         this.heightImage);
/*     */ 
/* 642 */       if (i + j >= this.heightImage)
/* 643 */         paramGraphics.copyArea(this.widthImage, i, 
/* 644 */           this.widthImage, 1, -this.widthImage, 0);
/*     */       else
/* 646 */         paramGraphics.copyArea(this.widthImage, i + j, 
/* 647 */           this.widthImage, 1, -this.widthImage, -j);
/*     */     }
/*     */   }
/*     */ 
/*     */   private void makeWavesInverse(Graphics paramGraphics, int paramInt) {
/* 652 */     double d = 6.283185307179586D * paramInt / this.numFrames;
/* 653 */     int i = size().height;
/*     */ 
/* 655 */     for (int j = 0; j < this.heightImage; j++) {
/* 656 */       int k = (int)
/* 660 */         (this.heightImage / 14 * (
/* 657 */         j + 28.0D) * 
/* 658 */         Math.sin(this.heightImage / 14 * (this.heightImage - j) / (
/* 659 */         j + 1) + d) / 
/* 660 */         this.heightImage);
/*     */ 
/* 662 */       if (j - this.heightImage > k)
/* 663 */         paramGraphics.copyArea(0, i - this.heightImage + j, 
/* 664 */           this.widthImage, 1, 0, -(j << 1));
/*     */       else
/* 666 */         paramGraphics.copyArea(0, i - this.heightImage + j - k, 
/* 667 */           this.widthImage, 1, 0, k - (j << 1));
/*     */     }
/*     */   }
/*     */ 
/*     */   private void makeWavesInverseHorizon(Graphics paramGraphics, int paramInt) {
/* 672 */     double d = 6.283185307179586D * paramInt / this.numFrames;
/* 673 */     size();
/*     */ 
/* 675 */     for (int i = this.horizon; i < this.heightImage; i++) {
/* 676 */       int j = (int)
/* 681 */         (this.heightImage / 14 * (
/* 677 */         i - this.horizon + 28.0D) * 
/* 678 */         Math.sin(this.heightImage / 14 * (
/* 679 */         this.heightImage - i + this.horizon) / (
/* 680 */         i - this.horizon + 1) + d) / 
/* 681 */         this.heightImage);
/*     */ 
/* 683 */       if (i + j >= this.heightImage)
/* 684 */         paramGraphics.copyArea(this.widthImage, this.heightImage - i, 
/* 685 */           this.widthImage, 1, -this.widthImage, 0);
/*     */       else
/* 687 */         paramGraphics.copyArea(this.widthImage, this.heightImage - i + j, 
/* 688 */           this.widthImage, 1, -this.widthImage, -j);
/*     */     }
/*     */   }
/*     */ }

/* Location:           /Users/frederickk/Dropbox/Display Show/Development/C1/frederick/_download/lake (1)/
 * Qualified Name:     lake
 * JD-Core Version:    0.6.2
 */