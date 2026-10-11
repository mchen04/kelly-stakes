import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  HelpCircle, 
  Calculator, 
  ChevronRight, 
  DollarSign, 
  BarChart2, 
  Shield, 
  Smartphone,
  TrendingUp,
  AlertTriangle,
  BookOpen,
  Phone,
  Mail,
  MessageCircle,
  Settings,
  RefreshCw,
  Save,
  Zap,
  Target,
  Clock,
  Globe,
  CreditCard,
  Database,
  PlusCircle,
  MinusCircle
} from 'lucide-react';

const Help = () => {
  const [activeCategory, setActiveCategory] = useState('getting-started');

  const categories = [
    {
      id: 'getting-started',
      title: 'Getting Started',
      icon: BookOpen,
      topics: [
        {
          title: 'What is Kelly Stakes?',
          icon: HelpCircle,
          content: `Kelly Stakes is a premium calculator app that helps you make smarter betting decisions using the Kelly Criterion mathematical formula. It calculates the optimal percentage of your bankroll to wager based on your edge and the odds, maximizing long-term growth while minimizing risk.

Key features:
• Calculate optimal bet sizes instantly
• Save multiple bankroll presets
• Support for American, Decimal, and Fractional odds
• All calculations done locally on your device
• No account required - complete privacy`
        },
        {
          title: 'Quick Start Guide',
          icon: Zap,
          content: `Get started in 3 simple steps:

1. Enter Your Bankroll
   • Open the app and enter your total bankroll amount
   • This is the total money you're willing to risk

2. Input Bet Details
   • Enter the odds (in any format you prefer)
   • Enter your estimated win probability (0-100%)
   • The app automatically calculates the optimal bet size

3. Save as Preset (Optional)
   • Tap "Save as Preset" to store your bankroll configuration
   • Name your preset for easy access later
   • Switch between presets instantly`
        },
        {
          title: 'Understanding the Kelly Formula',
          icon: Calculator,
          content: `The Kelly Criterion formula is:
f = (p × b - q) / b

Where:
• f = fraction of bankroll to bet
• p = probability of winning
• q = probability of losing (1 - p)
• b = odds received on the bet

Example:
• Odds: +150 (2.5 decimal)
• Win probability: 60%
• Kelly percentage: 20% of bankroll

The app handles all calculations automatically!`
        }
      ]
    },
    {
      id: 'using-app',
      title: 'Using the App',
      icon: Smartphone,
      topics: [
        {
          title: 'Entering Odds',
          icon: BarChart2,
          content: `Kelly Stakes supports all major odds formats:

American Odds (+150, -200)
• Positive (+): Shows profit on $100 bet
• Negative (-): Shows amount to bet for $100 profit

Decimal Odds (2.50, 1.75)
• Shows total return per $1 bet
• Includes your stake in the return

Fractional Odds (3/2, 1/4)
• Traditional format showing profit ratio
• First number is profit, second is stake

The app automatically converts between formats!`
        },
        {
          title: 'Working with Presets',
          icon: Save,
          content: `Presets let you save different bankroll configurations:

Creating a Preset:
1. Set up your bankroll and preferences
2. Tap "Save as Preset"
3. Give it a memorable name
4. Access it anytime from the preset menu

Use Cases:
• Different bankrolls (sports vs stocks)
• Conservative vs aggressive strategies
• Multiple accounts or purposes
• Testing different approaches

Free version includes 1 preset. Additional presets available for $1.99 each.`
        },
        {
          title: 'Fractional Kelly',
          icon: Target,
          content: `The app supports fractional Kelly betting for more conservative approaches:

Full Kelly (100%)
• Maximum growth potential
• Higher variance and risk
• For experienced users

Half Kelly (50%)
• Recommended for most users
• Balances growth and safety
• Reduces volatility significantly

Quarter Kelly (25%)
• Very conservative approach
• Minimal risk of significant losses
• Good for beginners

Adjust the Kelly fraction slider to match your risk tolerance.`
        },
        {
          title: 'Bet History & Tracking',
          icon: Clock,
          content: `Track your betting performance over time:

Features:
• View recent calculations
• Track win/loss record
• Monitor bankroll growth
• Analyze betting patterns
• Export data for deeper analysis

All data stored locally on your device for complete privacy.`
        }
      ]
    },
    {
      id: 'advanced',
      title: 'Advanced Features',
      icon: TrendingUp,
      topics: [
        {
          title: 'Multiple Bankroll Management',
          icon: Database,
          content: `Manage multiple bankrolls effectively:

Strategies:
• Separate bankrolls for different sports
• Risk allocation across betting types
• Conservative vs aggressive accounts
• Testing new strategies safely

Tips:
• Use descriptive preset names
• Review and adjust regularly
• Track performance separately
• Maintain discipline with each bankroll`
        },
        {
          title: 'Using Kelly for Investments',
          icon: BarChart2,
          content: `The Kelly Criterion works for any probabilistic investment:

Stock Trading:
• Position sizing for trades
• Risk management for portfolios
• Options trading calculations

Crypto & Forex:
• Leverage decisions
• Portfolio allocation
• Risk/reward optimization

Just input your expected return probability and potential gains/losses.`
        },
        {
          title: 'Risk Management Settings',
          icon: Shield,
          content: `Customize risk parameters:

Maximum Bet Limit:
• Set a cap on any single bet
• Prevents overexposure
• Protects against calculation errors

Minimum Bankroll:
• Stop betting below this threshold
• Preserves capital for recovery
• Prevents going broke

Kelly Fraction Adjustment:
• Fine-tune aggressiveness
• Account for estimation errors
• Match your risk tolerance`
        }
      ]
    },
    {
      id: 'purchases',
      title: 'Purchases & Billing',
      icon: CreditCard,
      topics: [
        {
          title: 'In-App Purchases',
          icon: DollarSign,
          content: `Kelly Stakes offers simple, one-time purchases:

Free Version:
• Full calculator functionality
• 1 preset included
• All odds formats supported
• Complete privacy

Additional Presets:
• $1.99 per preset (one-time)
• No subscriptions
• No recurring charges
• Instant activation

All purchases processed securely through Apple App Store.`
        },
        {
          title: 'How to Purchase',
          icon: PlusCircle,
          content: `Buying additional presets is easy:

1. Tap "Add Preset" button
2. Confirm purchase ($1.99)
3. Authenticate with Face ID/Touch ID
4. Preset instantly available

Purchase FAQ:
• Tied to your Apple ID
• Restore purchases on new devices
• Family Sharing supported
• No hidden fees`
        },
        {
          title: 'Refund Policy',
          icon: RefreshCw,
          content: `Refunds are handled through Apple:

How to Request:
1. Go to reportaproblem.apple.com
2. Sign in with your Apple ID
3. Find the Kelly Stakes purchase
4. Select "Report a Problem"
5. Choose refund reason

Note: Apple decides all refund requests. We cannot process refunds directly.`
        }
      ]
    },
    {
      id: 'safety',
      title: 'Safety & Responsibility',
      icon: AlertTriangle,
      topics: [
        {
          title: 'Responsible Gambling',
          icon: Shield,
          content: `Kelly Stakes promotes responsible gambling:

Golden Rules:
• Never bet more than you can afford to lose
• The Kelly Criterion assumes accurate probabilities
• Past performance doesn't guarantee future results
• Set strict limits and stick to them
• Take regular breaks from gambling

Warning Signs:
• Chasing losses
• Betting with borrowed money
• Lying about gambling
• Neglecting responsibilities
• Feeling anxious about betting`
        },
        {
          title: 'Getting Help',
          icon: Phone,
          content: `If you need help with gambling problems:

National Problem Gambling Helpline:
📞 1-800-522-4700
Available 24/7, confidential support

Online Resources:
• ncpgambling.org
• gamblersanonymous.org
• begambleaware.org

Remember: Kelly Stakes is a tool for mathematical calculations only. Always gamble responsibly within your means.`
        },
        {
          title: 'Age Restrictions',
          icon: MinusCircle,
          content: `You must be 18+ to use Kelly Stakes.

Legal Requirements:
• Sports betting age varies by jurisdiction
• Check your local laws
• App is for educational purposes
• We don't facilitate actual betting
• Your responsibility to comply with laws

By using the app, you confirm you are of legal age.`
        }
      ]
    },
    {
      id: 'troubleshooting',
      title: 'Troubleshooting',
      icon: Settings,
      topics: [
        {
          title: 'Common Issues',
          icon: AlertTriangle,
          content: `Solutions to frequent problems:

App Won't Open:
• Force quit and restart
• Check for iOS updates
• Ensure sufficient storage
• Reinstall if necessary

Calculations Seem Wrong:
• Verify odds format selection
• Check probability is 0-100%
• Ensure bankroll is entered correctly
• Try fractional Kelly for safety

Preset Won't Save:
• Check available storage
• Ensure unique preset name
• Try restarting app
• Contact support if persists`
        },
        {
          title: 'Purchase Issues',
          icon: CreditCard,
          content: `Resolving purchase problems:

Purchase Failed:
• Check internet connection
• Verify payment method
• Ensure App Store signed in
• Try again later

Can't Restore Purchases:
• Use same Apple ID
• Check internet connection
• Go to Settings > Restore Purchases
• Contact Apple Support if needed

Preset Not Appearing:
• Force quit and restart app
• Check purchase completed
• Tap Restore Purchases
• Contact support with receipt`
        },
        {
          title: 'Restoring Data',
          icon: RefreshCw,
          content: `How to restore your data:

Presets:
• Purchases tied to Apple ID
• Use "Restore Purchases" in settings
• Sign in with purchasing Apple ID

Calculations:
• Stored locally only
• Cannot be restored after deletion
• Consider screenshots for important calcs

Best Practices:
• Regular screenshots of key presets
• Note important calculations
• Keep purchase receipts`
        }
      ]
    },
    {
      id: 'contact',
      title: 'Contact & Support',
      icon: MessageCircle,
      topics: [
        {
          title: 'Contact Information',
          icon: Mail,
          content: `We're here to help!

Email Support:
📧 kellystakesapp@gmail.com
• Response within 24-48 hours
• Include iOS version and device model
• Attach screenshots if relevant

For Legal/Privacy:
📧 kellystakesapp@gmail.com

For Business Inquiries:
📧 kellystakesapp@gmail.com`
        },
        {
          title: 'Before Contacting Support',
          icon: HelpCircle,
          content: `Help us help you faster:

Include in Your Message:
• Device model (iPhone 12, etc.)
• iOS version
• App version
• Description of issue
• Steps to reproduce
• Screenshots if applicable

Common Quick Fixes:
• Restart the app
• Check for app updates
• Verify iOS is updated
• Try on WiFi vs cellular`
        },
        {
          title: 'Feature Requests',
          icon: PlusCircle,
          content: `We love hearing from users!

How to Submit Ideas:
• Email kellystakesapp@gmail.com
• Describe the feature clearly
• Explain how it would help
• Include use case examples

Popular Requests We're Considering:
• Cloud sync
• More preset slots in free version
• Widget support
• Apple Watch app
• Advanced statistics

Your feedback shapes Kelly Stakes!`
        }
      ]
    }
  ];

  const activeTopics = categories.find(cat => cat.id === activeCategory)?.topics || [];

  return (
    <section className="min-h-screen bg-black text-white py-20">
      <div className="max-w-6xl mx-auto px-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
        >
          <div className="text-center mb-12">
            <h1 className="text-4xl sm:text-5xl font-bold mb-4">Help Center</h1>
            <p className="text-xl text-gray-400">Everything you need to know about Kelly Stakes</p>
          </div>

          {/* Category Navigation */}
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-7 gap-4 mb-12">
            {categories.map((category) => {
              const Icon = category.icon;
              return (
                <button
                  key={category.id}
                  onClick={() => setActiveCategory(category.id)}
                  className={`p-4 rounded-xl border transition-all duration-200 ${
                    activeCategory === category.id
                      ? 'bg-green-500/20 border-green-500 text-green-400'
                      : 'bg-gray-900/50 border-gray-800 text-gray-300 hover:border-gray-700'
                  }`}
                >
                  <Icon className="w-6 h-6 mx-auto mb-2" />
                  <p className="text-sm font-medium">{category.title}</p>
                </button>
              );
            })}
          </div>

          {/* Active Category Topics */}
          <div className="grid gap-6">
            {activeTopics.map((topic, index) => {
              const TopicIcon = topic.icon;
              return (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: index * 0.1 }}
                  className="bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-xl p-6"
                >
                  <div className="flex items-start gap-4">
                    <TopicIcon className="w-6 h-6 text-green-400 flex-shrink-0 mt-1" />
                    <div className="flex-1">
                      <h3 className="text-xl font-bold text-white mb-3">{topic.title}</h3>
                      <div className="text-gray-300 leading-relaxed whitespace-pre-line">
                        {topic.content}
                      </div>
                    </div>
                  </div>
                </motion.div>
              );
            })}
          </div>

          {/* Quick Links */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.5 }}
            className="mt-12 grid sm:grid-cols-2 lg:grid-cols-3 gap-6"
          >
            <a
              href="mailto:kellystakesapp@gmail.com"
              className="bg-gray-900/50 border border-gray-800 rounded-xl p-6 hover:border-green-500/50 transition-all duration-200 group"
            >
              <Mail className="w-8 h-8 text-green-400 mb-4" />
              <h3 className="text-lg font-bold mb-2">Email Support</h3>
              <p className="text-gray-400 mb-4">Get help from our support team</p>
              <span className="text-green-400 group-hover:text-green-300 inline-flex items-center gap-2">
                Contact us <ChevronRight className="w-4 h-4" />
              </span>
            </a>

            <a
              href="#faq"
              className="bg-gray-900/50 border border-gray-800 rounded-xl p-6 hover:border-green-500/50 transition-all duration-200 group"
            >
              <HelpCircle className="w-8 h-8 text-green-400 mb-4" />
              <h3 className="text-lg font-bold mb-2">FAQ</h3>
              <p className="text-gray-400 mb-4">Quick answers to common questions</p>
              <span className="text-green-400 group-hover:text-green-300 inline-flex items-center gap-2">
                View FAQ <ChevronRight className="w-4 h-4" />
              </span>
            </a>

            <div className="bg-gray-900/50 border border-gray-800 rounded-xl p-6">
              <Phone className="w-8 h-8 text-green-400 mb-4" />
              <h3 className="text-lg font-bold mb-2">Gambling Help</h3>
              <p className="text-gray-400 mb-4">If you need help with gambling</p>
              <p className="text-green-400 font-mono">1-800-522-4700</p>
            </div>
          </motion.div>

          {/* Emergency Resources */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.7 }}
            className="mt-12 p-6 bg-yellow-500/10 border border-yellow-500/30 rounded-xl"
          >
            <div className="flex items-start gap-4">
              <AlertTriangle className="w-8 h-8 text-yellow-400 flex-shrink-0 mt-1" />
              <div>
                <h3 className="text-xl font-bold text-yellow-400 mb-2">Need Immediate Help?</h3>
                <p className="text-gray-300 mb-4">
                  If you or someone you know has a gambling problem:
                </p>
                <div className="space-y-2 text-gray-300">
                  <p>• National Problem Gambling Helpline: <span className="font-mono text-yellow-400">1-800-522-4700</span></p>
                  <p>• Text "GAMB" to <span className="font-mono text-yellow-400">1-800-522-4700</span></p>
                  <p>• Visit <a href="https://ncpgambling.org" className="text-yellow-400 hover:text-yellow-300">ncpgambling.org</a></p>
                </div>
              </div>
            </div>
          </motion.div>
        </motion.div>
      </div>
    </section>
  );
};

export default Help;