From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Tue, 11 Oct 2016 10:51:43 -0600
Message-ID: <20161011165143.GA6881@obsidianresearch.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161003171419.GE6801@obsidianresearch.com>
	<57F9C4C4.2070508@linux.vnet.ibm.com>
	<20161009232544.GC24139@obsidianresearch.com>
	<57FAF49D.7040009@linux.vnet.ibm.com>
	<20161010032113.GA26363@obsidianresearch.com>
	<57FB1551.9000806@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57FB1551.9000806-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 10, 2016 at 09:43:05AM +0530, Nayna wrote:
> 
> 
> On 10/10/2016 08:51 AM, Jason Gunthorpe wrote:
> >On Mon, Oct 10, 2016 at 07:23:33AM +0530, Nayna wrote:
> >
> >>And we pass this as private data to i_node in tpm_bios_log_setup.
> >
> >>So, we are referring chip as i_node->i_private->chip.
> >
> >That probably works, but you can't use the i_private = NULL scheme I
> >outlined with that.
> 
> Why ? we are doing i_private = NULL during teardown to imply that chip
> unregister is in progress. and no more securityfs operations should be done.
> So, whether chip is NULL or securityfs_data is NULL, either should be ok.
> Isn't it ?

How does release() work if you have to do:

  put_device(&((const struct tpm_securityfs_data *)inode->i_private)->chip.dev)

i_private could be null

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
