# Functions to make summary plots of NuSTAR solar data
# 
# Work in progress and missing comments/documentation
# 
# 15-Aug-2021 IGH
# 24-Jun-2022 IGH - Updated to use better avg1m XRS (need to supply filename)

from astropy.io import fits
import astropy.time as atime
from astropy.timeseries import TimeSeries
import astropy.units as u
from astropy.coordinates import SkyCoord

import numpy as np
import matplotlib

import matplotlib.pyplot as plt
import matplotlib.colors as colors
from matplotlib.colors import LogNorm

import nustar_pysolar as nustar
import sunpy.map
import sunpy.visualization.colormaps as cm
from sunpy.coordinates import frames
from sunpy import timeseries as ts
from sunpy.net import Fido
from sunpy.net import attrs as a

from scipy import ndimage

import warnings
warnings.simplefilter('ignore')
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def plot_ltc_chu_nsidab(maindir,nsid,\
                        lvyr=[5e-4,1.1],cryr=[8e3,8e5],crscl='log',\
                        outdir='figs/',wide=False,tmaj=10,tmin=2,timer=0):
    """
    Summary lightcurves of a NuSTAR Solar pointing

    Inputs

    A:
        some text
    B:
        some text

   
    Outputs

    None, saves out a fig
  

    """  
    fevta=maindir+nsid+'/event_cl/nu'+nsid+'A06_cl.evt'
    fhka=maindir+nsid+'/hk/nu'+nsid+'A_fpm.hk'
    fevtb=maindir+nsid+'/event_cl/nu'+nsid+'B06_cl.evt'
    fhkb=maindir+nsid+'/hk/nu'+nsid+'B_fpm.hk'
    fca=maindir+nsid+'/hk/nu'+nsid+'_chu123.fits'
    
    hdulist = fits.open(fevta)
    evda=hdulist[1].data
    hdra = hdulist[1].header
    hdulist.close()

    hdulist = fits.open(fhka)
    lda=hdulist[1].data
    lhdra = hdulist[1].header
    hdulist.close()

    hdulist = fits.open(fevtb)
    evdb=hdulist[1].data
    hdrb = hdulist[1].header
    hdulist.close()

    hdulist = fits.open(fhkb)
    ldb=hdulist[1].data
    lhdrb = hdulist[1].header
    hdulist.close()
    
    mjdref=atime.Time(hdra['mjdrefi'],format='mjd')
    
    lvta=lda['livetime']
    ltimsa=atime.Time(mjdref+lda['time']*u.s,format='mjd')
    timsa=atime.Time(mjdref+evda['time']*u.s,format='mjd')
    hista, bea=np.histogram((timsa-ltimsa[0]).sec,bins=(ltimsa-ltimsa[0]).sec)
    bda=np.where(hista == 0.0)

    lvtb=ldb['livetime']
    ltimsb=atime.Time(mjdref+ldb['time']*u.s,format='mjd')
    timsb=atime.Time(mjdref+evdb['time']*u.s,format='mjd')
    histb, beb=np.histogram((timsb-ltimsb[0]).sec,bins=(ltimsb-ltimsb[0]).sec)
    bdb=np.where(histb == 0.0)
    
    if hasattr(timer,'__len__'):
        if len(timer) == 2:
            mint=timer[0].iso
            maxt=timer[1].iso
    else:
        mint=ltimsa[0].iso
        maxt=ltimsa[-1].iso 
        
    min_date=matplotlib.dates.datestr2num(mint)
    max_date=matplotlib.dates.datestr2num(maxt)

    myFmt = matplotlib.dates.DateFormatter('%H:%M')
    majorx= matplotlib.dates.MinuteLocator(interval=tmaj)
    minorx= matplotlib.dates.MinuteLocator(interval=tmin)
    
#   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   stuff for the CHU info
    clist = fits.open(fca)
    cdata1=clist[1].data
    cdata2=clist[2].data
    cdata3=clist[3].data
    chdr = clist[1].header
    clist.close()
    
    ctims=atime.Time(mjdref+cdata3['time']*u.s,format='mjd')
    
    maxres=20
    c1mask=np.all([[cdata1['valid'] == 1],[cdata1['residual'] < maxres],\
                  [cdata1['starsfail'] < cdata1['objects']],[cdata1['chuq'][:,3] != 1]],axis=0)
    # These give True or Flase back so multiplying by number gives number or 0
    c1mask=c1mask[0]*1
    c2mask=np.all([[cdata2['valid'] == 1],[cdata2['residual'] < maxres],\
                  [cdata2['starsfail'] < cdata2['objects']],[cdata2['chuq'][:,3] != 1]],axis=0)
    c2mask=(c2mask[0]*4)
    c3mask=np.all([[cdata3['valid'] == 1],[cdata3['residual'] < maxres],\
                  [cdata3['starsfail'] < cdata3['objects']],[cdata3['chuq'][:,3] != 1]],axis=0)
    c3mask=(c3mask[0]*9)
    mask=c1mask+c2mask+c3mask
    # Tweak the mask labelling to make plotting easier
    # Maybe not the best way of doing this....
    newmask=np.zeros(len(mask))
    newmask[np.where(mask ==1)]=1
    newmask[np.where(mask ==4)]=2
    newmask[np.where(mask ==5)]=3
    newmask[np.where(mask ==9)]=4
    newmask[np.where(mask ==10)]=5
    newmask[np.where(mask ==13)]=6
    newmask[np.where(mask ==14)]=7
#     just to get rid of weird stuff
    newmask[np.where(mask ==0)]=np.nan
    
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    plt.rcParams.update({'font.size': 16,'font.family':"sans-serif",\
                         'font.sans-serif':"Arial",'mathtext.default':"regular"})
    
    clr0a='rebeccapurple'
    clr1a='darkgray'
    clr0b='teal'
    clr1b='darkgray'
    
    if wide == True:
        fig = plt.figure(figsize=(12,11))
    else:
        fig = plt.figure(figsize=(7,11))       
    
    ax1 = fig.add_subplot(3, 1, 1)
    plt.plot_date(ltimsa.datetime, lvta, \
                  drawstyle='steps-post',marker=None,ls='solid',color=clr1a)
    lvtagd=np.copy(lvta)
    lvtagd[bda]=np.nan
    ax1.plot_date(ltimsa.datetime, lvtagd, \
                  drawstyle='steps-post',marker=None,ls='solid',color=clr0a)
    lvtbgd=np.copy(lvtb)
    lvtbgd[bdb]=np.nan
    ax1.plot_date(ltimsb.datetime, lvtbgd, \
                  drawstyle='steps-post',marker=None,ls='solid',color=clr0b)
    ax1.set_yscale('log')
    ax1.set_title(nsid+'AB')
    ax1.set_ylim(lvyr)
    ax1.set_yscale('log')
    ax1.set_ylabel("Livetime")
    ax1.set_xlim([min_date,max_date])
    ax1.xaxis.set_major_locator(majorx)
    ax1.xaxis.set_minor_locator(minorx)
    ax1.tick_params(labelbottom=False)
    ax1.grid(axis='x',zorder=0,ls='--')
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ax2 = fig.add_subplot(3, 1, 2)
    ax2.plot_date(ctims.datetime, newmask, color='darkgoldenrod',marker='+',mew=2,ms=7)
    
    ax2.set_yticklabels([' ','1','2','12','3','13','23','123',' '])
    ax2.set_ylabel('CHU State')
    ax2.set_ylim([0,8])
    ax2.locator_params(axis="y", nbins=9)
    ax2.set_xlim([min_date,max_date])
    ax2.xaxis.set_major_locator(majorx)
    ax2.xaxis.set_minor_locator(minorx)
    ax2.tick_params(labelbottom=False)
    ax2.grid(axis='x',zorder=0,ls='--')
          
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ax3 = fig.add_subplot(3, 1, 3)
    
    cragd=hista/lvta[:-1]
    cragd[bda]=np.nan
    crbgd=histb/lvtb[:-1]
    crbgd[bdb]=np.nan

    titlab='On: '+"{0:.2f}".format(hdra['ontime'])+'s, Exp: '+\
        "{0:.2f}".format(hdra['exposure'])+'s'
    leglaba='A ('+\
        "{0:.2f}".format(100*hdra['exposure']/hdra['ontime'])+'%)'
    leglabb='B ('+\
        "{0:.2f}".format(100*hdrb['exposure']/hdrb['ontime'])+'%)'
    ax3.plot_date(ltimsa[:-1].datetime,cragd,label=leglaba,\
                  drawstyle='steps-post',marker=None,ls='solid',color=clr0a)
    ax3.plot_date(ltimsb[:-1].datetime,crbgd,label=leglabb,\
                  drawstyle='steps-post',marker=None,ls='solid',color=clr0b)
    ax3.set_ylim(cryr)
    ax3.set_title(titlab)
    ax3.set_yscale(crscl)
    ax3.set_xlabel("Start Time "+mint[0:19]+" (UTC)")
    ax3.set_ylabel("NuSTAR count s$^{-1}$")
    ax3.set_xlim([min_date,max_date])
    ax3.xaxis.set_major_locator(majorx)
    ax3.xaxis.set_minor_locator(minorx)
    ax3.xaxis.set_major_formatter(myFmt)
    ax3.grid(axis='x',zorder=0,ls='--')
    ax3.legend(fontsize=14,loc=0)
    #---------------------------------------------------
    fig.tight_layout(pad=1,rect=[0.01,0.01,1,0.98])
    plt.savefig(outdir+nsid+'AB_cltc.png')
    plt.close()
    
    return


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def plot_ltc_chu_nsid(maindir,nsid,fpm,\
                        lvyr=[5e-4,1.1],cryr=[8e3,8e5],crscl='log',\
                        outdir='figs/',wide=False,tmaj=10,tmin=2,timer=0):
    """
    Summary lightcurves of a NuSTAR Solar pointing

    Inputs

    A:
        some text
    B:
        some text

   
    Outputs

    None, saves out a fig
  

    """  
    fevta=maindir+nsid+'/event_cl/nu'+nsid+fpm+'06_cl.evt'
    fhka=maindir+nsid+'/hk/nu'+nsid+fpm+'_fpm.hk'
    fca=maindir+nsid+'/hk/nu'+nsid+'_chu123.fits'
    
    hdulist = fits.open(fevta)
    evda=hdulist[1].data
    hdra = hdulist[1].header
    hdulist.close()

    hdulist = fits.open(fhka)
    lda=hdulist[1].data
    lhdra = hdulist[1].header
    hdulist.close()
    
    mjdref=atime.Time(hdra['mjdrefi'],format='mjd')
    
    lvta=lda['livetime']
    ltimsa=atime.Time(mjdref+lda['time']*u.s,format='mjd')
    timsa=atime.Time(mjdref+evda['time']*u.s,format='mjd')
    hista, bea=np.histogram((timsa-ltimsa[0]).sec,bins=(ltimsa-ltimsa[0]).sec)
    bda=np.where(hista == 0.0)
    
    if hasattr(timer,'__len__'):
        if len(timer) == 2:
            mint=timer[0].iso
            maxt=timer[1].iso
    else:
        mint=ltimsa[0].iso
        maxt=ltimsa[-1].iso 
        
    min_date=matplotlib.dates.datestr2num(mint)
    max_date=matplotlib.dates.datestr2num(maxt)

    myFmt = matplotlib.dates.DateFormatter('%H:%M')
    majorx= matplotlib.dates.MinuteLocator(interval=tmaj)
    minorx= matplotlib.dates.MinuteLocator(interval=tmin)
    
#   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   stuff for the CHU info
    clist = fits.open(fca)
    cdata1=clist[1].data
    cdata2=clist[2].data
    cdata3=clist[3].data
    chdr = clist[1].header
    clist.close()
    
    ctims=atime.Time(mjdref+cdata3['time']*u.s,format='mjd')
    
    maxres=20
    c1mask=np.all([[cdata1['valid'] == 1],[cdata1['residual'] < maxres],\
                  [cdata1['starsfail'] < cdata1['objects']],[cdata1['chuq'][:,3] != 1]],axis=0)
    # These give True or Flase back so multiplying by number gives number or 0
    c1mask=c1mask[0]*1
    c2mask=np.all([[cdata2['valid'] == 1],[cdata2['residual'] < maxres],\
                  [cdata2['starsfail'] < cdata2['objects']],[cdata2['chuq'][:,3] != 1]],axis=0)
    c2mask=(c2mask[0]*4)
    c3mask=np.all([[cdata3['valid'] == 1],[cdata3['residual'] < maxres],\
                  [cdata3['starsfail'] < cdata3['objects']],[cdata3['chuq'][:,3] != 1]],axis=0)
    c3mask=(c3mask[0]*9)
    mask=c1mask+c2mask+c3mask
    # Tweak the mask labelling to make plotting easier
    # Maybe not the best way of doing this....
    newmask=np.zeros(len(mask))
    newmask[np.where(mask ==1)]=1
    newmask[np.where(mask ==4)]=2
    newmask[np.where(mask ==5)]=3
    newmask[np.where(mask ==9)]=4
    newmask[np.where(mask ==10)]=5
    newmask[np.where(mask ==13)]=6
    newmask[np.where(mask ==14)]=7
#     just to get rid of weird stuff
    newmask[np.where(mask ==0)]=np.nan
    
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    plt.rcParams.update({'font.size': 16,'font.family':"sans-serif",\
                         'font.sans-serif':"Arial",'mathtext.default':"regular"})
    
    if fpm == 'A':
        clr0='rebeccapurple'
        clr1='darkgray'
    if fpm == 'B':
        clr0='teal'
        clr1='darkgray'
    
    if wide == True:
        fig = plt.figure(figsize=(12,11))
    else:
        fig = plt.figure(figsize=(7,11))       
    
    ax1 = fig.add_subplot(3, 1, 1)
    plt.plot_date(ltimsa.datetime, lvta, \
                  drawstyle='steps-post',marker=None,ls='solid',color=clr1)
    lvtagd=np.copy(lvta)
    lvtagd[bda]=np.nan
    ax1.plot_date(ltimsa.datetime, lvtagd, \
                  drawstyle='steps-post',marker=None,ls='solid',color=clr0)
    ax1.set_yscale('log')
    ax1.set_title(nsid+fpm)
    ax1.set_ylim(lvyr)
    ax1.set_yscale('log')
    ax1.set_ylabel("Livetime")
    ax1.set_xlim([min_date,max_date])
    ax1.xaxis.set_major_locator(majorx)
    ax1.xaxis.set_minor_locator(minorx)
    ax1.tick_params(labelbottom=False)
    ax1.grid(axis='x',zorder=0,ls='--')
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ax2 = fig.add_subplot(3, 1, 2)
    ax2.plot_date(ctims.datetime, newmask, color='darkgoldenrod',marker='+',mew=2,ms=7)
    
    ax2.set_yticklabels([' ','1','2','12','3','13','23','123',' '])
    ax2.set_ylabel('CHU State')
    ax2.set_ylim([0,8])
    ax2.locator_params(axis="y", nbins=9)
    ax2.set_xlim([min_date,max_date])
    ax2.xaxis.set_major_locator(majorx)
    ax2.xaxis.set_minor_locator(minorx)
    ax2.tick_params(labelbottom=False)
    ax2.grid(axis='x',zorder=0,ls='--')
          
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ax3 = fig.add_subplot(3, 1, 3)
    
    cragd=hista/lvta[:-1]
    cragd[bda]=np.nan
    leglab='On: '+"{0:.2f}".format(hdra['ontime'])+'s, Exp: '+\
        "{0:.2f}".format(hdra['exposure'])+'s ('+\
        "{0:.2f}".format(100*hdra['exposure']/hdra['ontime'])+'%)'
    ax3.plot_date(ltimsa[:-1].datetime,cragd,label=leglab,\
                  drawstyle='steps-post',marker=None,ls='solid',color=clr0)
    ax3.set_ylim(cryr)
    ax3.set_title(leglab)
    ax3.set_yscale(crscl)
    ax3.set_xlabel("Start Time "+mint[0:19]+" (UTC)")
    ax3.set_ylabel("NuSTAR count s$^{-1}$")
    ax3.set_xlim([min_date,max_date])
    ax3.xaxis.set_major_locator(majorx)
    ax3.xaxis.set_minor_locator(minorx)
    ax3.xaxis.set_major_formatter(myFmt)
    ax3.grid(axis='x',zorder=0,ls='--')
#     ax3.legend(fontsize=16,loc=1)
    #---------------------------------------------------
    fig.tight_layout(pad=1,rect=[0.01,0.01,1,0.98])
    plt.savefig(outdir+nsid+fpm+'_cltc.png')
    plt.close()
    
    return


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def plot_ltc_chu_ges_nsid(maindir,nsid,fpm,\
                          lvyr=[5e-4,1.1],cryr=[8e3,8e5],crscl='log',\
                          gsyr=[1e-8,1e-6],gsscl='linear',gsmfs=5,gsfile='',\
                          outdir='figs/',wide=False,tmaj=10,tmin=2,timer=0):
    """
    Summary lightcurves of a NuSTAR Solar pointing

    Inputs

    A:
        some text
    B:
        some text

   
    Outputs

    None, saves out a fig
  

    """  
    fevta=maindir+nsid+'/event_cl/nu'+nsid+fpm+'06_cl.evt'
    fhka=maindir+nsid+'/hk/nu'+nsid+fpm+'_fpm.hk'
    fca=maindir+nsid+'/hk/nu'+nsid+'_chu123.fits'
    
    hdulist = fits.open(fevta)
    evda=hdulist[1].data
    hdra = hdulist[1].header
    hdulist.close()

    hdulist = fits.open(fhka)
    lda=hdulist[1].data
    lhdra = hdulist[1].header
    hdulist.close()
    
    mjdref=atime.Time(hdra['mjdrefi'],format='mjd')
    
    lvta=lda['livetime']
    ltimsa=atime.Time(mjdref+lda['time']*u.s,format='mjd')
    timsa=atime.Time(mjdref+evda['time']*u.s,format='mjd')
    hista, bea=np.histogram((timsa-ltimsa[0]).sec,bins=(ltimsa-ltimsa[0]).sec)
    bda=np.where(hista == 0.0)
    
    if hasattr(timer,'__len__'):
        if len(timer) == 2:
            mint=timer[0].iso
            maxt=timer[1].iso
    else:
        mint=ltimsa[0].iso
        maxt=ltimsa[-1].iso 
        
    min_date=matplotlib.dates.datestr2num(mint)
    max_date=matplotlib.dates.datestr2num(maxt)

    myFmt = matplotlib.dates.DateFormatter('%H:%M')
    majorx= matplotlib.dates.MinuteLocator(interval=tmaj)
    minorx= matplotlib.dates.MinuteLocator(interval=tmin)
    
#   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   stuff for the CHU info
    clist = fits.open(fca)
    cdata1=clist[1].data
    cdata2=clist[2].data
    cdata3=clist[3].data
    chdr = clist[1].header
    clist.close()
    
    ctims=atime.Time(mjdref+cdata3['time']*u.s,format='mjd')
    
    maxres=20
    c1mask=np.all([[cdata1['valid'] == 1],[cdata1['residual'] < maxres],\
                  [cdata1['starsfail'] < cdata1['objects']],[cdata1['chuq'][:,3] != 1]],axis=0)
    # These give True or Flase back so multiplying by number gives number or 0
    c1mask=c1mask[0]*1
    c2mask=np.all([[cdata2['valid'] == 1],[cdata2['residual'] < maxres],\
                  [cdata2['starsfail'] < cdata2['objects']],[cdata2['chuq'][:,3] != 1]],axis=0)
    c2mask=(c2mask[0]*4)
    c3mask=np.all([[cdata3['valid'] == 1],[cdata3['residual'] < maxres],\
                  [cdata3['starsfail'] < cdata3['objects']],[cdata3['chuq'][:,3] != 1]],axis=0)
    c3mask=(c3mask[0]*9)
    mask=c1mask+c2mask+c3mask
    # Tweak the mask labelling to make plotting easier
    # Maybe not the best way of doing this....
    newmask=np.zeros(len(mask))
    newmask[np.where(mask ==1)]=1
    newmask[np.where(mask ==4)]=2
    newmask[np.where(mask ==5)]=3
    newmask[np.where(mask ==9)]=4
    newmask[np.where(mask ==10)]=5
    newmask[np.where(mask ==13)]=6
    newmask[np.where(mask ==14)]=7
#     just to get rid of weird stuff
    newmask[np.where(mask ==0)]=np.nan
    
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Get the GOES/XRS stuff
    if gsfile =='':
        ges_res = Fido.search(a.Time(mint,maxt),a.Instrument("XRS"),a.goes.SatelliteNumber(16))
        file_ges = Fido.fetch(ges_res,progress=False)
    else:
        file_ges=gsfile

    goesd = ts.TimeSeries(file_ges,concatenate=True)
    
#   This is loading in a full day file and if covering more than one day then 2 list entry, so
    # if hasattr(goesd, "__len__"):
    #     gestims=np.concatenate((goesd[0].index,goesd[1].index))
    #     gesb=np.concatenate((goesd[0].quantity("xrsb").value,goesd[1].quantity("xrsb").value))
    #     sortid=np.argsort(gestims)
    #     gestims=gestims[sortid]
    #     gesb=gesb[sortid]
    # else:
    gestims=goesd.index
    gesb=goesd.quantity("xrsb").value
        
#   Do a median filter over gsmfs sec on GOES data to remove dodgy spikes (due to instrumental things?)
# Only need with 1s data
    if gsfile =='':
        gesb=ndimage.median_filter(gesb, size=gsmfs)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    plt.rcParams.update({'font.size': 16,'font.family':"sans-serif",\
                         'font.sans-serif':"Arial",'mathtext.default':"regular"})
    
    if fpm == 'A':
        clr0='rebeccapurple'
        clr1='darkgray'
    if fpm == 'B':
        clr0='teal'
        clr1='darkgray'
    
    if wide == True:
        fig = plt.figure(figsize=(12,11))
    else:
        fig = plt.figure(figsize=(7,11))       
    
    ax1 = fig.add_subplot(4, 1, 1)
    plt.plot_date(ltimsa.datetime, lvta, \
                  drawstyle='steps-post',marker=None,ls='solid',color=clr1)
    lvtagd=np.copy(lvta)
    lvtagd[bda]=np.nan
    ax1.plot_date(ltimsa.datetime, lvtagd, \
                  drawstyle='steps-post',marker=None,ls='solid',color=clr0)
    ax1.set_yscale('log')
    ax1.set_title(nsid+fpm)
    ax1.set_ylim(lvyr)
    ax1.set_yscale('log')
    ax1.set_ylabel("Livetime")
    ax1.set_xlim([min_date,max_date])
    ax1.xaxis.set_major_locator(majorx)
    ax1.xaxis.set_minor_locator(minorx)
    ax1.tick_params(labelbottom=False)
    ax1.grid(axis='x',zorder=0,ls='--')
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ax2 = fig.add_subplot(4, 1, 2)
    ax2.plot_date(ctims.datetime, newmask, color='darkgoldenrod',marker='+',mew=2,ms=7)
    
    ax2.set_yticklabels([' ','1','2','12','3','13','23','123',' '])
    ax2.set_ylabel('CHU State')
    ax2.set_ylim([0,8])
    ax2.locator_params(axis="y", nbins=9)
    ax2.set_xlim([min_date,max_date])
    ax2.xaxis.set_major_locator(majorx)
    ax2.xaxis.set_minor_locator(minorx)
    ax2.tick_params(labelbottom=False)
    ax2.grid(axis='x',zorder=0,ls='--')
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ax3 = fig.add_subplot(4, 1, 3)
    ax3.plot_date(gestims,gesb,'-',lw=1,color='firebrick',marker=None)
    
    ax3.set_ylabel('GOES Flux W m$^{-1}$')
    ax3.set_ylim(gsyr)
    ax3.set_yscale(gsscl)
    ax3.set_xlim([min_date,max_date])
    ax3.xaxis.set_major_locator(majorx)
    ax3.xaxis.set_minor_locator(minorx)
    ax3.tick_params(labelbottom=False)
    ax3.grid(axis='x',zorder=0,ls='--')
       
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ax4 = fig.add_subplot(4, 1, 4)
    
    cragd=hista/lvta[:-1]
    cragd[bda]=np.nan
    leglab='On: '+"{0:.2f}".format(hdra['ontime'])+'s, Exp: '+\
        "{0:.2f}".format(hdra['exposure'])+'s ('+\
        "{0:.2f}".format(100*hdra['exposure']/hdra['ontime'])+'%)'
    ax4.plot_date(ltimsa[:-1].datetime,cragd,label=leglab,\
                  drawstyle='steps-post',marker=None,ls='solid',color=clr0)
#     plt.plot_date(ltimsa[:-1].datetime,hista/lvta[:-1],label='FPMA',\
#                   drawstyle='steps-post',marker=None,ls='solid',color='rebeccapurple')
    ax4.set_ylim(cryr)
    ax4.set_title(leglab)
    ax4.set_yscale(crscl)
    ax4.set_xlabel("Start Time "+mint[0:19]+" (UTC)")
    ax4.set_ylabel("NuSTAR count s$^{-1}$")
    ax4.set_xlim([min_date,max_date])
    ax4.xaxis.set_major_locator(majorx)
    ax4.xaxis.set_minor_locator(minorx)
    ax4.xaxis.set_major_formatter(myFmt)
    ax4.grid(axis='x',zorder=0,ls='--')
#     ax4.legend(fontsize=16,loc=1)
    #---------------------------------------------------
    fig.tight_layout(pad=1,rect=[0.01,0.01,1,0.98])
    plt.savefig(outdir+nsid+fpm+'_cgltc.png')
    plt.close()
    
    return

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def plot_fdmap_nsid(maindir,nsid,fpm,outdir='figs/',xyr=1300,\
                      englo=2.,enghi=10.,vmin=1e-3,vmax=1e0):
    """
    Full disk map of a pointing

    Inputs

    A:
        some text
    B:
        some text

   
    Outputs

    None, saves out a fig
  

    """      

    fevta=maindir+nsid+'/event_cl/nu'+nsid+fpm+'06_cl_sunpos.evt'
    fhka=maindir+nsid+'/hk/nu'+nsid+fpm+'_fpm.hk'
    
    hdulist = fits.open(fevta)
    evda=hdulist[1].data
    hdra = hdulist[1].header
    hdulist.close()

    hdulist = fits.open(fhka)
    lda=hdulist[1].data
    lhdra = hdulist[1].header
    hdulist.close()
    
    mjdref=atime.Time(hdra['mjdrefi'],format='mjd')
    
    evt1 = nustar.filter.event_filter(evda,fpm=fpm,energy_low=englo, energy_high=enghi,hdr=hdra)
    timer=[atime.Time(mjdref+np.min(evt1['time'])*u.s,format='mjd'),\
        atime.Time(mjdref+np.max(evt1['time'])*u.s,format='mjd')]

    nmap1 = nustar.map.make_sunpy(evt1, hdra,norm_map=True)
    
    blxy=[-1*xyr,-1*xyr]
    trxy=[xyr,xyr]
    bottom_left = SkyCoord(blxy[0]* u.arcsec, blxy[1] * u.arcsec, frame=nmap1.coordinate_frame)
    top_right = SkyCoord(trxy[0] * u.arcsec, trxy[1] * u.arcsec, frame=nmap1.coordinate_frame)
    snmap1= nmap1.submap(bottom_left=bottom_left, top_right=top_right)
    
    plt.rcParams.update({'font.size': 16,'font.family':"sans-serif",\
                     'font.sans-serif':"Arial",'mathtext.default':"regular"})

    fig = plt.figure(figsize=(8,7))
    snmap1.plot(norm=colors.LogNorm(vmin=vmin,vmax=vmax),cmap='inferno')
    plt.figtext(0.02,0.02,nsid+fpm+\
        " ({:.2f}".format(100*hdra['livetime']/hdra['ontime'])+"%)",color='black',ha='left')
    axx=plt.gca()
    axx.set_ylabel('y [arcsec]')
    axx.set_xlabel('x [arcsec]')
    axx.grid(False)
    axx.set_title(timer[0].iso[0:10]+' '+timer[0].iso[11:19]+'$-$'+timer[1].iso[11:19]+", "+\
        "{:.1f}".format(englo)+'$-$'+"{:.1f}".format(enghi)+' keV')
    tx, ty = axx.coords
    ty._formatter_locator.show_decimal_unit = False
    tx._formatter_locator.show_decimal_unit = False
    overlay = axx.get_coords_overlay('heliographic_stonyhurst')
    lon = overlay[0]
    lat = overlay[1]
    lon.set_ticks(spacing=15*u.deg)
    lat.set_ticks(spacing=15*u.deg)
    lon.set_ticks_visible(False)
    lat.set_ticks_visible(False)
    lat.set_ticklabel_visible(False)
    lon.set_ticklabel_visible(False)
    lon.coord_wrap = 180
    lon.set_major_formatter('dd')
    overlay.grid(color='grey', linewidth=1, linestyle='dashed',alpha=0.5)
    plt.colorbar(fraction=0.035, pad=0.02,label='count s$^{-1}$')

    fig.tight_layout(pad=1,rect=[0.15,0.05,1,0.98])
    plt.savefig(outdir+nsid+fpm+'_fdmap.png')
    plt.close()
    
    return


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

def plot_map_nsid(maindir,nsid,fpm,outdir='figs/',hlfv=500*u.arcsec,\
                      englo=2.,enghi=10.,vmin=1e-3,vmax=1e0,resample=False,rsp=100):
    """
    Zoomed in map of a pointing

    Inputs

    A:
        some text
    B:
        some text

   
    Outputs

    None, saves out a fig
  

    """      

    fevta=maindir+nsid+'/event_cl/nu'+nsid+fpm+'06_cl_sunpos.evt'
    fhka=maindir+nsid+'/hk/nu'+nsid+fpm+'_fpm.hk'
    
    hdulist = fits.open(fevta)
    evda=hdulist[1].data
    hdra = hdulist[1].header
    hdulist.close()

    hdulist = fits.open(fhka)
    lda=hdulist[1].data
    lhdra = hdulist[1].header
    hdulist.close()
    
    mjdref=atime.Time(hdra['mjdrefi'],format='mjd')
    
    evt1 = nustar.filter.event_filter(evda,fpm=fpm,energy_low=englo, energy_high=enghi,hdr=hdra)
    timer=[atime.Time(mjdref+np.min(evt1['time'])*u.s,format='mjd'),\
        atime.Time(mjdref+np.max(evt1['time'])*u.s,format='mjd')]
    txtlab= nsid+fpm+" ({:.2f}".format(100*hdra['livetime']/hdra['ontime'])+"%)"

    nmap1 = nustar.map.make_sunpy(evt1, hdra,norm_map=True)
    
    sum0=np.sum(nmap1.data,0)
    sum1=np.sum(nmap1.data,1)
    cen0=np.mean(np.where(sum0 !=0.0))*u.pixel
    cen1=np.mean(np.where(sum1 !=0.0))*u.pixel
    
    cen_coord=nmap1.pixel_to_world(cen0,cen1)   
    bottom_left = SkyCoord(cen_coord.Tx - hlfv, cen_coord.Ty - hlfv, frame=nmap1.coordinate_frame)
    top_right = SkyCoord(cen_coord.Tx + hlfv, cen_coord.Ty + hlfv, frame=nmap1.coordinate_frame)
    
    if resample == True:
        snmap0= nmap1.submap(bottom_left=bottom_left, top_right=top_right)
        snmap1= snmap0.resample([rsp, rsp] * u.pixel)
        txtlab=txtlab+" RS"
    else:
        snmap1= nmap1.submap(bottom_left=bottom_left, top_right=top_right)
    
    plt.rcParams.update({'font.size': 16,'font.family':"sans-serif",\
                     'font.sans-serif':"Arial",'mathtext.default':"regular"})

    fig = plt.figure(figsize=(8,7))
    snmap1.plot(norm=colors.LogNorm(vmin=vmin,vmax=vmax),cmap='inferno')
    plt.figtext(0.02,0.02,txtlab,color='black',ha='left')
    axx=plt.gca()
    axx.set_ylabel('y [arcsec]')
    axx.set_xlabel('x [arcsec]')
    axx.grid(False)
    axx.set_title(timer[0].iso[0:10]+' '+timer[0].iso[11:19]+'$-$'+timer[1].iso[11:19]+", "+\
        "{:.1f}".format(englo)+'$-$'+"{:.1f}".format(enghi)+' keV')
    tx, ty = axx.coords
    ty._formatter_locator.show_decimal_unit = False
    tx._formatter_locator.show_decimal_unit = False
    overlay = axx.get_coords_overlay('heliographic_stonyhurst')
    lon = overlay[0]
    lat = overlay[1]
    lon.set_ticks(spacing=15*u.deg)
    lat.set_ticks(spacing=15*u.deg)
    lon.set_ticks_visible(False)
    lat.set_ticks_visible(False)
    lat.set_ticklabel_visible(False)
    lon.set_ticklabel_visible(False)
    lon.coord_wrap = 180
    lon.set_major_formatter('dd')
    overlay.grid(color='black', linewidth=1, linestyle='dashed',alpha=1.0)
    plt.colorbar(fraction=0.035, pad=0.02,label='count s$^{-1}$')

    fig.tight_layout(pad=1,rect=[0.15,0.05,1,0.98])
    plt.savefig(outdir+nsid+fpm+'_map.png')
    plt.close()
    
    return