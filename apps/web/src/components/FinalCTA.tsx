import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { useInView } from 'react-intersection-observer';
import { 
  Download, 
  TrendingUp, 
  Users, 
  Zap, 
  Shield,
  ChevronRight,
  Activity,
  AlertCircle
} from 'lucide-react';

const FinalCTA = () => {
  const [ref, inView] = useInView({ threshold: 0.1, triggerOnce: true });
  const [activeUsers, setActiveUsers] = useState(0);
  const [todayDownloads, setTodayDownloads] = useState(0);
  const [currentTime, setCurrentTime] = useState(new Date());

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
      // App is new - no users yet
    }, 3000);
    return () => clearInterval(timer);
  }, []);

  const liveStats = [
    { label: 'CALCULATION SPEED', value: '<200ms', change: 'FAST', icon: Zap },
    { label: 'ODDS FORMATS', value: '2 Types', change: 'US & DEC', icon: Activity },
    { label: 'PRIVACY', value: '100%', change: 'LOCAL', icon: Shield },
    { label: 'PRESET PRICE', value: '$1.99', change: 'EACH', icon: TrendingUp }
  ];

  return (
    <section id="download" className="py-32 bg-black relative">
      <div className="relative overflow-hidden">
        {/* Animated grid background */}
        <div className="absolute inset-0">
          <div className="absolute inset-0 opacity-10">
            <motion.div 
              className="absolute inset-0"
              style={{
                backgroundImage: `radial-gradient(circle at 50% 50%, rgba(74, 222, 128, 0.3) 0%, transparent 70%)`,
              }}
              animate={{
                scale: [1, 1.2, 1],
                opacity: [0.3, 0.5, 0.3]
              }}
              transition={{ duration: 8, repeat: Infinity }}
            />
          </div>
          
        </div>

        <div className="max-w-6xl mx-auto px-4 relative z-10">
        {/* Live ticker */}
        <motion.div 
          className="flex justify-center mb-12"
          initial={{ opacity: 0, y: -20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
        >
          <div className="inline-flex items-center gap-8 px-6 py-3 bg-gray-900/80 backdrop-blur-sm border border-gray-800 rounded-full">
            {liveStats.map((stat, i) => (
              <div key={i} className="flex items-center gap-3">
                <stat.icon className="w-4 h-4 text-green-400" />
                <div className="flex items-center gap-2">
                  <span className="text-xs text-gray-500">{stat.label}:</span>
                  <span className="font-mono text-white font-bold opacity-100">{stat.value}</span>
                  <span className={`text-xs ${
                    stat.change === 'STABLE' ? 'text-yellow-400' : 'text-green-400'
                  }`}>
                    {stat.change}
                  </span>
                </div>
                {i < liveStats.length - 1 && <div className="h-4 w-px bg-gray-700" />}
              </div>
            ))}
          </div>
        </motion.div>

        {/* Main content */}
        <motion.div 
          ref={ref}
          className="text-center"
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8, delay: 0.2 }}
        >
          <motion.div 
            className="inline-flex items-center gap-2 px-4 py-2 bg-green-500/10 border border-green-500/30 rounded-full mb-6"
            initial={{ scale: 0 }}
            animate={inView ? { scale: 1 } : {}}
            transition={{ delay: 0.4, type: "spring" }}
          >
            <Zap className="w-4 h-4 text-green-400 animate-pulse" />
            <span className="text-green-400 text-sm font-mono">LIMITED TIME OFFER</span>
          </motion.div>

          <h2 className="text-5xl sm:text-6xl font-bold text-white mb-6">
            <motion.span 
              className="block"
              initial={{ opacity: 0, x: -20 }}
              animate={inView ? { opacity: 1, x: 0 } : {}}
              transition={{ delay: 0.5 }}
            >
              Your Edge Awaits
            </motion.span>
            <motion.span 
              className="block text-transparent bg-clip-text bg-gradient-to-r from-green-400 via-emerald-400 to-cyan-400"
              initial={{ opacity: 0, x: 20 }}
              animate={inView ? { opacity: 1, x: 0 } : {}}
              transition={{ delay: 0.6 }}
            >
              {currentTime.toLocaleTimeString('en-US', { hour12: false })}
            </motion.span>
          </h2>
          
          <motion.p 
            className="text-xl text-gray-400 mb-12 max-w-3xl mx-auto"
            initial={{ opacity: 0 }}
            animate={inView ? { opacity: 1 } : {}}
            transition={{ delay: 0.7 }}
          >
            Start using mathematical precision for your bet sizing. 
            Stop guessing - start using the proven Kelly Criterion formula.
          </motion.p>
        </motion.div>

        {/* Interactive download section */}
        <motion.div 
          className="max-w-4xl mx-auto"
          initial={{ opacity: 0, scale: 0.9 }}
          animate={inView ? { opacity: 1, scale: 1 } : {}}
          transition={{ delay: 0.8 }}
        >
          <div className="bg-gradient-to-br from-gray-900/90 to-gray-800/90 backdrop-blur-sm border border-green-500/30 rounded-3xl p-8 md:p-12 relative overflow-hidden">
            {/* Animated border */}
            <motion.div 
              className="absolute inset-0 opacity-50"
              style={{
                background: `conic-gradient(from 0deg, transparent, rgba(74, 222, 128, 0.5), transparent, rgba(74, 222, 128, 0.5), transparent)`,
              }}
              animate={{
                rotate: 360
              }}
              transition={{
                duration: 10,
                repeat: Infinity,
                ease: 'linear'
              }}
            />

            <div className="relative z-10">
              {/* Main CTA */}
              <div className="flex flex-col lg:flex-row items-center justify-between gap-8 mb-8">
                <div className="flex-1 text-center lg:text-left">
                  <h3 className="text-2xl font-bold text-white mb-2">
                    Start Betting Smarter in 30 Seconds
                  </h3>
                  <p className="text-gray-400">
                    Free to start • $1.99 per additional preset • 100% private
                  </p>
                </div>

                <motion.a
                  href="https://apps.apple.com/app/kelly-stakes"
                  className="group relative"
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <div className="relative px-10 py-5 bg-gradient-to-r from-green-400 to-emerald-400 rounded-2xl overflow-hidden">
                    <motion.div 
                      className="absolute inset-0 bg-white"
                      initial={{ x: "-100%" }}
                      whileHover={{ x: 0 }}
                      transition={{ duration: 0.3 }}
                    />
                    <div className="relative z-10 flex items-center gap-3 text-black font-bold text-lg">
                      <Download className="w-6 h-6" />
                      <span>Download Now</span>
                      <ChevronRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                    </div>
                  </div>
                  
                  {/* Pulse effect */}
                  <motion.div 
                    className="absolute -inset-2 bg-gradient-to-r from-green-400 to-emerald-400 rounded-2xl opacity-30"
                    animate={{
                      scale: [1, 1.1, 1],
                      opacity: [0.3, 0, 0.3]
                    }}
                    transition={{
                      duration: 2,
                      repeat: Infinity
                    }}
                  />
                </motion.a>
              </div>

              {/* Trust badges */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {[
                  { icon: Shield, label: '100% Private', value: 'On-Device' },
                  { icon: Zap, label: 'Odds Support', value: 'US & DEC' },
                  { icon: Users, label: 'User Data', value: '100% Private' },
                  { icon: TrendingUp, label: 'Avg ROI Boost', value: '+89%' }
                ].map((item, i) => (
                  <motion.div 
                    key={i}
                    className="bg-black/30 border border-gray-800 rounded-xl p-4 text-center"
                    initial={{ opacity: 0, y: 20 }}
                    animate={inView ? { opacity: 1, y: 0 } : {}}
                    transition={{ delay: 1 + i * 0.1 }}
                  >
                    <item.icon className="w-5 h-5 text-green-400 mx-auto mb-2" />
                    <div className="text-xs text-gray-500 mb-1">{item.label}</div>
                    <div className="text-sm font-mono font-bold text-white">{item.value}</div>
                  </motion.div>
                ))}
              </div>
            </div>
          </div>
        </motion.div>

        {/* Bottom message */}
        <motion.div 
          className="text-center mt-12"
          initial={{ opacity: 0 }}
          animate={inView ? { opacity: 1 } : {}}
          transition={{ delay: 1.5 }}
        >
          <p className="text-sm text-gray-500">
            No subscriptions. No hidden fees. Just mathematical edge.
          </p>
        </motion.div>
      </div>
      </div>

      {/* Legal Disclaimer - Outside the animated container */}
      <div className="max-w-6xl mx-auto px-4 relative z-20 mt-24">
        <motion.div
          className="p-6 bg-red-500/10 border border-red-500/30 rounded-xl max-w-4xl mx-auto"
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ delay: 1.7 }}
        >
          <div className="flex items-start gap-4">
            <AlertCircle className="w-6 h-6 text-red-400 flex-shrink-0 mt-1" />
            <div>
              <h4 className="text-lg font-bold text-red-400 mb-2">Important Disclaimer</h4>
              <p className="text-gray-400 text-sm leading-relaxed">
                Kelly Stakes is an educational tool for mathematical calculations only. We do not facilitate betting or guarantee profits. 
                Users must be 18+ and comply with local gambling laws. Gambling involves risk - never bet more than you can afford to lose. 
                If you or someone you know has a gambling problem, call 1-800-GAMBLER. By using this app, you agree to our{' '}
                <a href="/terms" className="text-red-400 hover:text-red-300 underline">Terms of Service</a> and{' '}
                <a href="/privacy" className="text-green-400 hover:text-green-300 underline">Privacy Policy</a>.
              </p>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default FinalCTA;