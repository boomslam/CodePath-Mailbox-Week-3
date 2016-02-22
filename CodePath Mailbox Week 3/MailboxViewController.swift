//
//  MailboxViewController.swift
//  CodePath Mailbox Week 3
//
//  Created by Jess Lam on 2/20/16.
//  Copyright © 2016 Jess Lam. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    //outlets
    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var singleMessageView: UIImageView!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var feedWrapperView: UIView!
    @IBOutlet weak var mainWrapperView: UIView!
    @IBOutlet weak var menuView: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var rightIconView: UIView!
    @IBOutlet weak var leftIconView: UIView!
    
    @IBOutlet weak var listIconView: UIImageView!
    @IBOutlet weak var laterIconView: UIImageView!
    @IBOutlet weak var deleteIconView: UIImageView!
    @IBOutlet weak var archiveIconView: UIImageView!
    
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    
    //variables - positions for message
    var singleMessageInitialCenter: CGPoint!
    var rightPosition: CGFloat!
    var leftPosition: CGFloat!
    var snapCenter: CGFloat!
    
    //variables - feed wrapper
    var feedWrapperViewInitialY: CGFloat!
    var feedWrapperViewOffset: CGFloat!
    
    //variables to turn views on and off
    var singleMessageLater: Bool!
    var singleMessageArchived: Bool!
    var singleMessageDeleted: Bool!
    var singleMessageMoved: Bool!
    var mainWrapperSwiped: Bool!
    
    //main wrapper view variables
    var mainWrapperInitialCenter: CGPoint!
    var mainWrapperOriginalPosition: CGFloat!
    var mainWrapperRightPosition: CGFloat!
    var mainWrapperStartRightPositionX: CGFloat!
    var mainWrapperStartRightPosition: CGPoint!
    
    //variables for colors
    var lightGrey: UIColor!
    var green: UIColor!
    var red: UIColor!
    var yellow: UIColor!
    var brown: UIColor!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedScrollView.contentSize = CGSize(width: 320, height: 1346)
        
        //values for position variables
        snapCenter = singleMessageView.center.x
        rightPosition = singleMessageView.center.x + 320
        leftPosition = singleMessageView.center.x - 320
        
        //initial states of later and list menues
        rescheduleView.alpha = 0
        listView.alpha = 0
        
        //values for icon variables
        singleMessageLater = false
        singleMessageArchived = false
        singleMessageDeleted = false
        singleMessageMoved = false
        mainWrapperSwiped = false
        
        //set feed wrapper view values
        feedWrapperViewInitialY = feedWrapperView.frame.origin.y
        feedWrapperViewOffset = -88
        
        //initiate pan edge recognizer
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "didPanEdgeMainView:")
        mainWrapperView.addGestureRecognizer(edgeGesture)
        
        //set menu view positions
        mainWrapperOriginalPosition = mainWrapperView.center.x
        mainWrapperRightPosition = mainWrapperView.center.x + 280
        mainWrapperStartRightPositionX = mainWrapperView.center.x + 280
        
        //set color values
        lightGrey = UIColor(red: 229/255, green: 230/255, blue: 233/255, alpha: 1.0)
        green = UIColor(red: 98/255, green: 214/255, blue: 80/255, alpha: 1.0)
        red = UIColor(red: 229/255, green: 62/255, blue: 39/255, alpha: 1.0)
        yellow = UIColor(red: 233/255, green: 189/255, blue: 38/255, alpha: 1.0)
        brown = UIColor(red: 207/255, green: 150/255, blue: 99/255, alpha: 1.0)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //pan message
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        print(translation.x)
    
        //pan begins
        if sender.state == UIGestureRecognizerState.Began {
            print("Did pan view begin.")
            singleMessageInitialCenter = singleMessageView.center
            
        }
        
        //pan changes
        else if sender.state == UIGestureRecognizerState.Changed {
            print("Did pan view changed.")
            singleMessageView.center = CGPoint(x: translation.x + singleMessageInitialCenter.x, y: singleMessageInitialCenter.y)
            
            //alpha conversions
            let leftIconViewConvertedAlpha = convertValue(translation.x, r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
            leftIconView.alpha = CGFloat(leftIconViewConvertedAlpha)
            let rightIconViewConvertedAlpha = convertValue(translation.x, r1Min: 0, r1Max: -60, r2Min: 0, r2Max: 1)
            rightIconView.alpha = CGFloat(rightIconViewConvertedAlpha)

            
            //translation conversions
            let leftIconViewConvertedTranslation = convertValue(translation.x, r1Min: 60, r1Max: 320, r2Min: 0, r2Max: 260)
            let rightIconViewConvertedTranslation = convertValue(translation.x,r1Min: -60, r1Max: -320, r2Min: 0, r2Max: -260)
            
            //pan right less than 60, gray bg, move back to center
            if translation.x >= 0 && translation.x < 60 {
                print("translation.x > 0")
                messageBackgroundView.backgroundColor = lightGrey
                listIconView.hidden = true
                laterIconView.hidden = true
                archiveIconView.hidden = false
                deleteIconView.hidden = true
            }
            
            //pan to right more than 60, green bg, move offscreen
            else if translation.x >= 60 && translation.x < 260 {
                print("translation.x > 60")
                messageBackgroundView.backgroundColor = green
                leftIconView.transform = CGAffineTransformMakeTranslation(leftIconViewConvertedTranslation, 0)
                listIconView.hidden = true
                laterIconView.hidden = true
                archiveIconView.hidden = false
                deleteIconView.hidden = true
            }
            
            //pan to right more than 260, red bg, move offscreen
            else if translation.x > 260 {
                print("translation.x > 260")
                messageBackgroundView.backgroundColor = red
                leftIconView.transform = CGAffineTransformMakeTranslation(leftIconViewConvertedTranslation, 0)
                listIconView.hidden = true
                laterIconView.hidden = true
                archiveIconView.hidden = true
                deleteIconView.hidden = false
                
            }
            
            //pan left less than 60 and see gray bg and later icon
            else if translation.x <= 0 && translation.x > -60 {
                print("translation.x < 0")
                messageBackgroundView.backgroundColor = lightGrey
                listIconView.hidden = true
                laterIconView.hidden = false
                archiveIconView.hidden = true
                deleteIconView.hidden = true
            }
            
            //pan left to show later icon and yello bg
            else if translation.x <= -60 && translation.x > -260 {
                print("translation.x < -60")
                messageBackgroundView.backgroundColor = yellow
                rightIconView.transform = CGAffineTransformMakeTranslation(rightIconViewConvertedTranslation, 0)
                listIconView.hidden = true
                laterIconView.hidden = false
                archiveIconView.hidden = true
                deleteIconView.hidden = true
            }
            
            //pan left more than 260 to show list icon and brown bg color
            else if translation.x <= -260 {
                print("translation.x < -260")
                messageBackgroundView.backgroundColor = brown
                rightIconView.transform = CGAffineTransformMakeTranslation(rightIconViewConvertedTranslation, 0)
                listIconView.hidden = false
                laterIconView.hidden = true
                archiveIconView.hidden = true
                deleteIconView.hidden = true
            }
            
        }
        
        else if sender.state == UIGestureRecognizerState.Ended {
            print("Did pan view ended.")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                //pan to right, move message offscreen and archive
                if translation.x >= 60 && translation.x < 260 {
                    print("translation.x ended > 60")
                    self.singleMessageView.center.x = self.rightPosition
                    self.singleMessageArchived = true
                    
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.archiveIconView.alpha = 0
                        }, completion: { (Bool) -> Void in
                            UIView.animateWithDuration(0.2, animations: { () -> Void in
                                self.feedWrapperView.frame.origin.y = self.feedWrapperViewInitialY + self.feedWrapperViewOffset
                            })
                    })
                }
                
                //pan to right and delete message
                else if translation.x >= 260 {
                    print("translation.x ended >= 260")
                    self.singleMessageView.center.x = self.rightPosition
                    self.singleMessageDeleted = true

                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.deleteIconView.alpha = 0
                        }, completion: { (Bool) -> Void in
                            UIView.animateWithDuration(0.2, animations: { () -> Void in
                                self.feedWrapperView.frame.origin.y = self.feedWrapperViewInitialY + self.feedWrapperViewOffset
                            })
                    })
                }
                
                //pan left and show later menu
                else if translation.x <= -60 && translation.x > -260 {
                    print("translation.x ended < -60")
                    self.singleMessageView.center.x = self.leftPosition
                    self.singleMessageLater = true
                    
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.laterIconView.alpha = 0
                    })
                    
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.rescheduleView.alpha = 1
                    })
                }
                
                //pan left and show list menu
                else if translation.x <= -260 {
                    print("translation.x ended < -260")
                    self.singleMessageView.center.x = self.leftPosition
                    self.singleMessageMoved = true
                    
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.listIconView.alpha = 0
                    })
                    
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.listView.alpha = 1
                    })
                }
                
                else {
                    print("ended translation.x < 60 or > -60")
                    self.singleMessageView.center.x = self.snapCenter
                }
                
            })
            
        }
        
    }

    //dismissing the reschedule menu
    @IBAction func didTapRescheduleView(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.rescheduleView.alpha = 0
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.feedWrapperView.frame.origin.y = self.feedWrapperViewInitialY + self.feedWrapperViewOffset
                })
        }
    }
    
    //dismiss list menu
    @IBAction func didTapListView(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.listView.alpha = 0
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.feedWrapperView.frame.origin.y = self.feedWrapperViewInitialY + self.feedWrapperViewOffset
                })
        }
        
    }
    
    //reset mailbox
    @IBAction func tapResetMailbox(sender: UITapGestureRecognizer) {
        singleMessageView.frame.origin.x = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.messageBackgroundView.hidden = false
            self.feedImageView.center.y += 88
            self.feedScrollView.contentSize.height += 88
            self.listIconView.hidden = false
            self.laterIconView.hidden = false
            self.archiveIconView.hidden = false
            self.deleteIconView.hidden = false
        }
    }
    
    
    //edge pan the main view. not working at the moment.
    @IBAction func didPanEdgeMainView(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        print("Edge panning + \(translation.x)")
        print(velocity.x)
        
        if sender.state == UIGestureRecognizerState.Began {
            print("edge pan began")
            mainWrapperInitialCenter = mainWrapperView.center
        }
        
        //move main wrapper center
        else if sender.state == UIGestureRecognizerState.Changed {
            print("edge pan changed")
            mainWrapperView.center = CGPoint(x: translation.x + mainWrapperInitialCenter.x, y: mainWrapperInitialCenter.y)
        }
        
        else if sender.state == UIGestureRecognizerState.Ended {
            print("edge pan ended")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0 {
                    self.mainWrapperView.center.x = self.mainWrapperRightPosition
                    self.mainWrapperSwiped = true
                }
                
                else if velocity.x < 0 {
                    self.mainWrapperView.center.x = self.mainWrapperOriginalPosition
                    self.mainWrapperSwiped = false
                }
            })
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
