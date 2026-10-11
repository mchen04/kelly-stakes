import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useInView } from 'react-intersection-observer';
import { TrendingUp, Star, BarChart3, CheckCircle, ArrowUp, ArrowDown } from 'lucide-react';

const Testimonials = () => {
  const [ref, inView] = useInView({ threshold: 0.1, triggerOnce: true });
  const [activeIndex, setActiveIndex] = useState(0);

  const research = [
    {
      name: 'John L. Kelly Jr.',
      role: 'Bell Labs, 1956',
      avatar: 'JK',
      year: 1956,
      journal: 'Bell System Technical Journal',
      impact: 'Original Paper',
      verified: true,
      text: 'A New Interpretation of Information Rate - The foundational paper that introduced the Kelly Criterion, showing how to maximize the exponential rate of growth of wealth in sequential investments.',
      stats: { citations: 5847, field: 'Information Theory', applications: 'Finance, Gambling, Portfolio Theory' },
      link: 'https://archive.org/details/bstj35-4-917'
    },
    {
      name: 'Edward O. Thorp',
      role: 'MIT Mathematics Professor',
      avatar: 'ET',
      year: 1962,
      journal: 'Beat the Dealer',
      impact: 'First Practical Application',
      verified: true,
      text: 'Applied Kelly Criterion to blackjack and later to financial markets. Demonstrated that the Kelly strategy beats any essentially different strategy in the long run.',
      stats: { citations: 3291, field: 'Applied Mathematics', applications: 'Blackjack, Stock Market, Sports Betting' },
      link: 'http://www.edwardothorp.com/books/'
    },
    {
      name: 'William Poundstone',
      role: 'Science Writer',
      avatar: 'WP',
      year: 2005,
      journal: 'Fortune\'s Formula',
      impact: 'Modern Analysis',
      verified: true,
      text: 'Documented how the Kelly Criterion has been used by successful investors and gamblers, from Las Vegas to Wall Street, showing its practical effectiveness.',
      stats: { citations: 892, field: 'Popular Science', applications: 'Investment Strategies, Risk Management' },
      link: 'https://www.amazon.com/Fortunes-Formula-Scientific-Betting-Casinos/dp/0809045990'
    }
  ];

  const marketMetrics = [
    { label: 'Kelly Formula', value: 'Proven', trend: 'up' },
    { label: 'Calculation Speed', value: '<200ms', trend: 'up' },
    { label: 'Odds Formats', value: '2 Types', trend: 'up' },
    { label: 'Privacy', value: '100%', trend: 'neutral' }
  ];

  return (
    <section id="testimonials" className="py-32 bg-black relative overflow-hidden">
      {/* Grid background */}
      <div className="absolute inset-0 opacity-5">
        <div className="absolute inset-0" style={{
          backgroundImage: `linear-gradient(rgba(0, 255, 0, 0.1) 1px, transparent 1px),
                           linear-gradient(90deg, rgba(0, 255, 0, 0.1) 1px, transparent 1px)`,
          backgroundSize: '50px 50px'
        }} />
      </div>

      <div className="max-w-7xl mx-auto px-4">
        <motion.div 
          ref={ref}
          className="text-center mb-20"
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
        >
          <motion.div 
            className="inline-flex items-center gap-2 px-4 py-2 bg-green-500/10 border border-green-500/30 rounded-full mb-6"
            initial={{ scale: 0 }}
            animate={inView ? { scale: 1 } : {}}
            transition={{ delay: 0.2, type: "spring" }}
          >
            <TrendingUp className="w-4 h-4 text-green-400" />
            <span className="text-green-400 text-sm font-mono">KELLY CRITERION RESEARCH</span>
          </motion.div>

          <h2 className="text-4xl sm:text-5xl font-bold text-white mb-6">
            <span className="block">Mathematical Edge.</span>
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-emerald-400">
              Proven Formula.
            </span>
          </h2>
        </motion.div>

        {/* Market metrics ticker */}
        <motion.div 
          className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-16"
          initial={{ opacity: 0 }}
          animate={inView ? { opacity: 1 } : {}}
          transition={{ delay: 0.4 }}
        >
          {marketMetrics.map((metric, i) => (
            <div key={i} className="bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-lg p-4">
              <div className="flex items-center justify-between mb-2">
                <span className="text-xs text-gray-500 uppercase">{metric.label}</span>
                {metric.trend === 'up' ? (
                  <ArrowUp className="w-4 h-4 text-green-400" />
                ) : metric.trend === 'down' ? (
                  <ArrowDown className="w-4 h-4 text-red-400" />
                ) : (
                  <div className="w-4 h-4 bg-yellow-400/20 rounded-full" />
                )}
              </div>
              <div className="text-2xl font-mono font-bold text-white">{metric.value}</div>
            </div>
          ))}
        </motion.div>

        {/* Main testimonial display */}
        <div className="grid lg:grid-cols-3 gap-8">
          {/* Testimonial cards */}
          <motion.div 
            className="lg:col-span-2 space-y-6"
            initial={{ opacity: 0, x: -50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ delay: 0.6 }}
          >
            <AnimatePresence mode="wait">
              {research.map((paper, index) => (
                index === activeIndex && (
                  <motion.div
                    key={index}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    transition={{ duration: 0.5 }}
                    className="bg-gray-900/90 backdrop-blur-sm border border-green-500/20 rounded-2xl p-8"
                  >
                    {/* Header */}
                    <div className="flex items-start justify-between mb-6">
                      <div className="flex items-center gap-4">
                        <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-green-400 to-emerald-400 flex items-center justify-center text-black font-bold text-xl">
                          {paper.avatar}
                        </div>
                        <div>
                          <div className="flex items-center gap-2">
                            <h3 className="text-xl font-bold text-white">{paper.name}</h3>
                            {paper.verified && (
                              <CheckCircle className="w-5 h-5 text-green-400" />
                            )}
                          </div>
                          <p className="text-gray-400">{paper.role}</p>
                          <p className="text-sm text-green-400 mt-1">{paper.journal}</p>
                        </div>
                      </div>
                      <div className="text-right">
                        <div className="text-3xl font-mono font-bold text-green-400">{paper.year}</div>
                        <div className="text-sm text-gray-500">{paper.impact}</div>
                      </div>
                    </div>

                    {/* Research Summary */}
                    <blockquote className="text-lg text-gray-300 mb-6 pl-4 border-l-2 border-green-500/50">
                      {paper.text}
                    </blockquote>

                    {/* Stats */}
                    <div className="grid grid-cols-3 gap-4 p-4 bg-black/30 rounded-lg">
                      <div>
                        <div className="text-xs text-gray-500 mb-1">CITATIONS</div>
                        <div className="text-xl font-mono text-white">{paper.stats.citations.toLocaleString()}</div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-500 mb-1">FIELD</div>
                        <div className="text-sm text-white">{paper.stats.field}</div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-500 mb-1">APPLICATIONS</div>
                        <div className="text-xs text-white">{paper.stats.applications}</div>
                      </div>
                    </div>

                    {/* Link to paper/book */}
                    {paper.link && (
                      <div className="mt-4 text-center">
                        <a 
                          href={paper.link}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="inline-flex items-center gap-2 text-sm text-green-400 hover:text-green-300 transition-colors"
                        >
                          <span>Read {paper.year === 1956 ? 'Paper' : 'More'}</span>
                          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                          </svg>
                        </a>
                      </div>
                    )}
                  </motion.div>
                )
              ))}
            </AnimatePresence>

            {/* Navigation dots */}
            <div className="flex justify-center gap-2">
              {research.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setActiveIndex(index)}
                  className={`w-2 h-2 rounded-full transition-all ${
                    index === activeIndex 
                      ? 'w-8 bg-green-400' 
                      : 'bg-gray-600 hover:bg-gray-500'
                  }`}
                />
              ))}
            </div>
          </motion.div>

          {/* Side panel - Performance chart */}
          <motion.div 
            className="bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-2xl p-6"
            initial={{ opacity: 0, x: 50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ delay: 0.8 }}
          >
            <h3 className="text-lg font-bold text-white mb-4 flex items-center gap-2">
              <BarChart3 className="w-5 h-5 text-green-400" />
              Kelly Performance
            </h3>
            
            {/* Mock performance chart */}
            <div className="h-48 relative mb-6">
              <svg className="w-full h-full" viewBox="0 0 300 200">
                <motion.path
                  d="M 0 180 L 50 160 L 100 140 L 150 100 L 200 80 L 250 40 L 300 20"
                  fill="none"
                  stroke="rgb(74, 222, 128)"
                  strokeWidth="3"
                  initial={{ pathLength: 0 }}
                  animate={{ pathLength: 1 }}
                  transition={{ duration: 2, delay: 1 }}
                />
                <motion.path
                  d="M 0 180 L 50 160 L 100 140 L 150 100 L 200 80 L 250 40 L 300 20 L 300 200 L 0 200 Z"
                  fill="url(#gradient-fill)"
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 0.2 }}
                  transition={{ duration: 1, delay: 1.5 }}
                />
                <defs>
                  <linearGradient id="gradient-fill" x1="0%" y1="0%" x2="0%" y2="100%">
                    <stop offset="0%" stopColor="rgb(74, 222, 128)" />
                    <stop offset="100%" stopColor="rgb(74, 222, 128)" stopOpacity="0" />
                  </linearGradient>
                </defs>
              </svg>
              
              {/* Y-axis labels */}
              <div className="absolute left-0 top-0 h-full flex flex-col justify-between text-xs text-gray-500">
                <span>+200%</span>
                <span>+100%</span>
                <span>0%</span>
              </div>
            </div>

            <div className="space-y-3">
              <div className="flex justify-between items-center p-3 bg-black/30 rounded">
                <span className="text-sm text-gray-400">Expected Growth*</span>
                <span className="font-mono text-green-400">Positive EV</span>
              </div>
              <div className="flex justify-between items-center p-3 bg-black/30 rounded">
                <span className="text-sm text-gray-400">Risk of 50% Loss</span>
                <span className="font-mono text-yellow-400">~33%</span>
              </div>
              <div className="flex justify-between items-center p-3 bg-black/30 rounded">
                <span className="text-sm text-gray-400">Variance</span>
                <span className="font-mono text-orange-400">HIGH</span>
              </div>
            </div>

            <div className="mt-4 p-3 bg-yellow-500/10 border border-yellow-500/30 rounded">
              <p className="text-xs text-yellow-400">
                *Kelly Criterion maximizes long-term growth rate when you have a true edge. 
                Results depend entirely on accurate probability estimates. Past academic 
                research does not guarantee future betting returns.
              </p>
            </div>

            <motion.button
              className="w-full mt-6 px-6 py-3 bg-gradient-to-r from-green-400 to-emerald-400 text-black font-bold rounded-lg"
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={() => window.location.href = '#download'}
            >
              Join Smart Bettors
            </motion.button>
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default Testimonials;