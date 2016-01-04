From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Mon, 04 Jan 2016 15:06:20 -0500
Message-ID: <1451937980.2772.91.camel@linux.vnet.ibm.com>
References: <20151218114131.GA3287@intel.com> <n5144n$1ug$1@ger.gmane.org>
	<9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
	<20151222212348.GB9461@obsidianresearch.com>	<n5ed19$pqo$1@ger.gmane.org>
	<20151224114241.GA5119@intel.com>	<n5h1rj$nkb$1@ger.gmane.org>
	<20160102203957.GA19490@obsidianresearch.com>
	<20160103135346.GA4047@intel.com>
	<9F48E1A823B03B4790B7E6E69430724DA5877E95@EXCH2010B.sit.fraunhofer.de>
	<20160104181915.GA15908@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160104181915.GA15908-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2016-01-04 at 20:19 +0200, Jarkko Sakkinen wrote:
> On Mon, Jan 04, 2016 at 04:22:25PM +0000, Fuchs, Andreas wrote:
> > > On Sat, Jan 02, 2016 at 01:39:57PM -0700, Jason Gunthorpe wrote:
> > > > Ie the first step would be to create a new /dev/ node for the
> > > > 'virtualized' tpm (vs the raw tpm we have now). We'd want to have some
> > > > idea exactly what that is and exactly what the UAPI looks like, and
> > > > make decsisions like, should there be one per tpm or one for all tpms?
> > > 
> > > Or you can get a new context when you open tpm device. There are
> > > multiple options.
> > 
> > I guess there are ways to add stuff.
> > 
> > I'd like to get a list of people interested to work on some conceptual stuff
> > first though.
> 
> I don't care in what process the patches are implemented. I can review
> and test patches once there is something real to be evaluated.

Jarkko is right.  At the end of the day, the code itself is what gets
reviewed.  To ease that review process, the code needs to be broken up
into manageable chunks known as patch sets.  Each patch set builds upon
previous patch sets, introducing a new feature/function with the
motivation for that feature described in the cover-letter.  Within a
patch set, patches need to be bi-sect safe, meaning it needs to build
cleanly after each patch.

Bottom line, break up the project and submit small incremental changes.

There's some documentation describing the upstreaming process:
- Documentation/SubmittingPatches
- Documentation/SubmitChecklist
- Documentation/SubmittingDrivers

Mimi


------------------------------------------------------------------------------
