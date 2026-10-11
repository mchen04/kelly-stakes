import { americanToDecimal, kellyFraction } from '@kelly-stakes/kelly';
import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useInView } from 'react-intersection-observer';
import { TrendingUp, Activity, BarChart3, Zap } from 'lucide-react';

const Hero = () => {
  const [ref, inView] = useInView({ threshold: 0.1, triggerOnce: true });
  const [givenOdds, setGivenOdds] = useState('+150'); // American odds format
  const [trueOdds, setTrueOdds] = useState('-120'); // Your estimated true odds
  const [bankroll] = useState(10000);
  const [optimalBet, setOptimalBet] = useState(909);
  const [animatedValue, setAnimatedValue] = useState(0);

  const decimalToProb = (decimal: number) => 1 / decimal;

  // Kelly Criterion calculation
  useEffect(() => {
    const givenDecimal = americanToDecimal(givenOdds);
    const trueDecimal = americanToDecimal(trueOdds);
    const fraction = kellyFraction(givenDecimal, 1 / trueDecimal);
    const kelly = fraction * 100;
    const betSize = Math.round(bankroll * (kelly / 100));
    setOptimalBet(Math.max(0, betSize));
  }, [givenOdds, trueOdds, bankroll]);

  // Animate optimal bet value
  useEffect(() => {
    const timer = setInterval(() => {
      setAnimatedValue((prev) => {
        const diff = optimalBet - prev;
        return prev + diff * 0.1;
      });
    }, 50);
    return () => clearInterval(timer);
  }, [optimalBet]);


  return (
    <section className="min-h-screen bg-black text-white overflow-hidden relative">
      {/* Trading terminal grid background */}
      <div className="absolute inset-0 opacity-5">
        <div className="absolute inset-0" style={{
          backgroundImage: `linear-gradient(rgba(0, 255, 0, 0.1) 1px, transparent 1px),
                           linear-gradient(90deg, rgba(0, 255, 0, 0.1) 1px, transparent 1px)`,
          backgroundSize: '50px 50px'
        }} />
      </div>


      <div className="max-w-7xl mx-auto px-4 pt-32 pb-16">
        <div className="grid lg:grid-cols-2 gap-12 items-center min-h-[80vh]">
          {/* Left content */}
          <motion.div 
            ref={ref}
            initial={{ opacity: 0, x: -50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.8 }}
          >
            <div className="mb-6">
              <motion.div 
                className="inline-flex items-center gap-2 px-4 py-2 bg-green-500/10 border border-green-500/30 rounded-full mb-6"
                initial={{ scale: 0 }}
                animate={inView ? { scale: 1 } : {}}
                transition={{ delay: 0.3, type: "spring" }}
              >
                <Zap className="w-4 h-4 text-green-400" />
                <span className="text-green-400 text-sm font-mono">LIVE CALCULATOR</span>
              </motion.div>
            </div>

            <h1 className="text-5xl lg:text-6xl font-bold mb-6 leading-tight">
              <motion.span 
                className="block"
                initial={{ y: 20, opacity: 0 }}
                animate={inView ? { y: 0, opacity: 1 } : {}}
                transition={{ delay: 0.4 }}
              >
                Trade With
              </motion.span>
              <motion.span 
                className="block text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-emerald-400"
                initial={{ y: 20, opacity: 0 }}
                animate={inView ? { y: 0, opacity: 1 } : {}}
                transition={{ delay: 0.5 }}
              >
                Mathematical Edge
              </motion.span>
            </h1>

            <motion.p 
              className="text-xl text-gray-400 mb-8 font-light"
              initial={{ opacity: 0 }}
              animate={inView ? { opacity: 1 } : {}}
              transition={{ delay: 0.6 }}
            >
              Premium iOS app for Kelly Criterion calculations. 
              Mathematically optimize bet sizing when you have a true edge.
              Remember: Kelly only works with accurate probability estimates.
            </motion.p>

            {/* Stats */}
            <motion.div 
              className="grid grid-cols-3 gap-4 mb-8"
              initial={{ opacity: 0, y: 20 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ delay: 0.7 }}
            >
              {[
                { icon: TrendingUp, value: '<200ms', label: 'Calculation Speed' },
                { icon: Activity, value: '100%', label: 'Private' },
                { icon: BarChart3, value: '2', label: 'Odds Formats' },
              ].map((stat, i) => (
                <div key={i} className="bg-gray-900/50 border border-gray-800 rounded-lg p-4">
                  <stat.icon className="w-5 h-5 text-green-400 mb-2" />
                  <div className="font-mono text-2xl font-bold text-white">{stat.value}</div>
                  <div className="text-xs text-gray-500">{stat.label}</div>
                </div>
              ))}
            </motion.div>

            {/* CTA */}
            <motion.div 
              className="flex flex-col sm:flex-row gap-4"
              initial={{ opacity: 0 }}
              animate={inView ? { opacity: 1 } : {}}
              transition={{ delay: 0.8 }}
            >
              <motion.a
                href="https://apps.apple.com/app/kelly-stakes"
                className="relative inline-flex items-center justify-center px-8 py-4 overflow-hidden font-bold text-black bg-gradient-to-r from-green-400 to-emerald-400 rounded-lg group"
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
              >
                <span className="relative z-10">Download Free</span>
                <motion.div 
                  className="absolute inset-0 bg-white"
                  initial={{ x: "-100%" }}
                  whileHover={{ x: 0 }}
                  transition={{ duration: 0.3 }}
                />
              </motion.a>

              <motion.button
                className="px-8 py-4 border border-gray-700 text-gray-300 rounded-lg font-semibold hover:border-green-500/50 hover:text-green-400 transition-all"
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                onClick={() => document.getElementById('live-demo')?.scrollIntoView({ behavior: 'smooth' })}
              >
                Try Live Demo
              </motion.button>
            </motion.div>
          </motion.div>

          {/* Right - Interactive Calculator */}
          <motion.div 
            className="relative"
            initial={{ opacity: 0, scale: 0.8 }}
            animate={inView ? { opacity: 1, scale: 1 } : {}}
            transition={{ delay: 0.5, duration: 0.8 }}
          >
            <div className="bg-gray-900/90 backdrop-blur-sm border border-green-500/20 rounded-2xl p-8 shadow-2xl relative overflow-hidden">
              {/* Terminal header */}
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded-full bg-red-500" />
                  <div className="w-3 h-3 rounded-full bg-yellow-500" />
                  <div className="w-3 h-3 rounded-full bg-green-500" />
                </div>
                <span className="text-xs text-gray-500 font-mono">KELLY_CALC_v2.0</span>
              </div>

              {/* Live calculation display */}
              <div className="bg-black/50 rounded-lg p-6 mb-6 border border-gray-800">
                <div className="flex items-center justify-between mb-4">
                  <span className="text-gray-400 text-sm">OPTIMAL POSITION</span>
                  <div className="flex items-center gap-2">
                    <div className="w-2 h-2 rounded-full bg-green-400 animate-pulse" />
                    <span className="text-xs text-green-400">LIVE</span>
                  </div>
                </div>
                
                <div className="text-5xl font-mono font-bold text-green-400 mb-2">
                  ${Math.round(animatedValue).toLocaleString()}
                </div>
                
                <div className="text-sm text-gray-500 font-mono">
                  {((animatedValue / bankroll) * 100).toFixed(2)}% of bankroll
                </div>

                {/* Mini chart */}
                <svg className="w-full h-16 mt-4" viewBox="0 0 200 40">
                  <motion.path
                    d="M 0 30 Q 50 20 100 25 T 200 15"
                    fill="none"
                    stroke="rgb(74, 222, 128)"
                    strokeWidth="2"
                    initial={{ pathLength: 0 }}
                    animate={{ pathLength: 1 }}
                    transition={{ duration: 2, delay: 1 }}
                  />
                </svg>
              </div>

              {/* Input controls */}
              <div className="space-y-4">
                <div>
                  <label className="text-xs text-gray-500 font-mono mb-1 block">YOUR_TRUE_ODDS</label>
                  <div className="flex gap-4 mb-2">
                    <button
                      onClick={() => setTrueOdds(prev => {
                        const num = parseInt(prev);
                        if (num < 0) return `${num + 5}`;
                        return `+${Math.max(100, num - 5)}`;
                      })}
                      className="px-3 py-2 bg-gray-800 hover:bg-gray-700 rounded text-gray-400"
                    >
                      -
                    </button>
                    <input
                      type="text"
                      value={trueOdds}
                      onChange={(e) => {
                        const val = e.target.value;
                        if (val.match(/^[+-]?\d*$/)) setTrueOdds(val);
                      }}
                      className="flex-1 bg-black/50 border border-gray-800 rounded px-4 py-2 text-center text-2xl font-mono text-green-400"
                      placeholder="-120"
                    />
                    <button
                      onClick={() => setTrueOdds(prev => {
                        const num = parseInt(prev);
                        if (num < 0) return `${Math.min(-100, num + 5)}`;
                        return `+${num + 5}`;
                      })}
                      className="px-3 py-2 bg-gray-800 hover:bg-gray-700 rounded text-gray-400"
                    >
                      +
                    </button>
                  </div>
                  <div className="text-xs text-gray-500 text-center">
                    Implied: {(decimalToProb(americanToDecimal(trueOdds)) * 100).toFixed(1)}%
                  </div>
                </div>

                <div>
                  <label className="text-xs text-gray-500 font-mono mb-1 block">GIVEN_ODDS</label>
                  <div className="flex gap-4 mb-2">
                    <button
                      onClick={() => setGivenOdds(prev => {
                        const num = parseInt(prev);
                        if (num < 0) return `${num + 5}`;
                        return `+${Math.max(100, num - 5)}`;
                      })}
                      className="px-3 py-2 bg-gray-800 hover:bg-gray-700 rounded text-gray-400"
                    >
                      -
                    </button>
                    <input
                      type="text"
                      value={givenOdds}
                      onChange={(e) => {
                        const val = e.target.value;
                        if (val.match(/^[+-]?\d*$/)) setGivenOdds(val);
                      }}
                      className="flex-1 bg-black/50 border border-gray-800 rounded px-4 py-2 text-center text-2xl font-mono text-green-400"
                      placeholder="+150"
                    />
                    <button
                      onClick={() => setGivenOdds(prev => {
                        const num = parseInt(prev);
                        if (num < 0) return `${Math.min(-100, num + 5)}`;
                        return `+${num + 5}`;
                      })}
                      className="px-3 py-2 bg-gray-800 hover:bg-gray-700 rounded text-gray-400"
                    >
                      +
                    </button>
                  </div>
                  <div className="text-xs text-gray-500 text-center">
                    Decimal: {americanToDecimal(givenOdds).toFixed(2)}
                  </div>
                </div>
              </div>

              {/* Formula display */}
              <div className="mt-6 p-3 bg-black/30 rounded border border-gray-800">
                <code className="text-xs text-green-400/70 font-mono">
                  Kelly % = (p × b - q) / b | p={((decimalToProb(americanToDecimal(trueOdds))) * 100).toFixed(1)}%, b={(americanToDecimal(givenOdds) - 1).toFixed(2)}
                </code>
              </div>
            </div>

            {/* Floating elements */}
            <motion.div 
              className="absolute -top-4 -right-4 w-20 h-20 bg-green-400/10 rounded-full blur-xl"
              animate={{ scale: [1, 1.2, 1], opacity: [0.5, 0.8, 0.5] }}
              transition={{ duration: 4, repeat: Infinity }}
            />
            <motion.div 
              className="absolute -bottom-4 -left-4 w-32 h-32 bg-blue-400/10 rounded-full blur-xl"
              animate={{ scale: [1, 1.3, 1], opacity: [0.3, 0.6, 0.3] }}
              transition={{ duration: 5, repeat: Infinity }}
            />
          </motion.div>
        </div>
      </div>

      <style jsx>{`
        input[type="range"]::-webkit-slider-thumb {
          appearance: none;
          width: 20px;
          height: 20px;
          background: rgb(74, 222, 128);
          cursor: pointer;
          border-radius: 50%;
          box-shadow: 0 0 10px rgba(74, 222, 128, 0.5);
        }
        input[type="range"]::-moz-range-thumb {
          width: 20px;
          height: 20px;
          background: rgb(74, 222, 128);
          cursor: pointer;
          border-radius: 50%;
          border: none;
          box-shadow: 0 0 10px rgba(74, 222, 128, 0.5);
        }
      `}</style>
    </section>
  );
};

export default Hero;
